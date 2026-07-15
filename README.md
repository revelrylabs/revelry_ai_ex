# RevelryAI: The RevelryAI Elixir SDK

RevelryAI allows for access to the powerful RevelryAI API via Elixir. 
This SDK allows for the creation and refinement of artifacts (content) within a RevelryAI team.
Other features include data center document, uploads, project management and more. 

## Motivation

To provide a simple way to interact with the RevelryAI API from within Elixir.

## Build Status

![tests](https://github.com/revelrylabs/revelry_ai_ex/actions/workflows/test.yml/badge.svg)

## Key Features
- Create and manage artifacts (content) within a RevelryAI team.
- Refine existing artifacts.
- Upload documents to RevelryAI data center.
- Stream the creation and refining of artifacts.
- Run skills and create artifacts asynchronously via the v2 API.

## Installation

Add RevelryAI to your mix.exs:

```elixir
def deps do
  [
    {:revelry_ai, "~> 0.3.0"}
  ]
end
```

Fetch dependencies:

```
mix deps.get
```

[Sign up for a RevelryAI account](https://app.revelry.ai) if you don't already
have one, then go to Settings -> Team -> Manage Team Details to get your API
key. If you don't see Manage Team Details, you will need to ask an administrator 
on your team for access. More into can be found on our [help site](https://help.revelry.ai/docs/api/get-your-api-token).

Put the API key somewhere in your application configuration, such as
`dev.secret.exs`:

```
config :revelry_ai, api_key: "YOUR_API_KEY"
```

## Usage

Every function returns `{:ok, result}` or `{:error, reason}`. Successful
responses share a common envelope — top-level keys are atoms, everything
nested keeps string keys:

```elixir
{:ok, %{status: "ok", response: %{"projects" => [...]}}}
```

Every function also takes an optional trailing keyword list to override
configuration per call — `api_key`, `api_url`, and `http_options`:

```elixir
RevelryAI.Project.list(api_key: "OTHER_TEAM_KEY")
```

### Validate your API key

```elixir
RevelryAI.Validate.validate_api_key()
#=> {:ok, %{status: "ok", response: %{"organization_id" => 1, "organization_name" => "Acme"}}}
```

### Projects

```elixir
RevelryAI.Project.list()
#=> {:ok, %{status: "ok", response: %{"projects" => [%{"id" => 1, "name" => "My Project"}, ...]}}}
```

### Artifact types

Every piece of content has an artifact type; its slug is used in most artifact
calls.

```elixir
RevelryAI.ArtifactType.list()
#=> {:ok, %{status: "ok", response: %{"artifact_types" => [%{"slug" => "story", ...}]}}}
```

### Skills

Skills define how content is generated — a prompt with custom variables,
document queries, and tool configuration. List the skills available for an
artifact type to find the `skill_id` used when creating artifacts or running
skills:

```elixir
RevelryAI.Skill.list("story")
#=> {:ok, %{status: "ok", response: %{"skills" => [%{"id" => 1, "name" => "Question Answering", ...}]}}}
```

### Artifacts (v1)

Create an artifact synchronously — the call blocks until generation finishes
and returns the artifact:

```elixir
params = %{
  skill_id: 2,
  inputs: [
    %{name: "Context", value: "this is a test"}
  ]
}

RevelryAI.Artifact.create("story", 1, params)
#=> {:ok, %{status: "ok", response: %{"artifact" => %{"id" => 123, "content" => "...", ...}, "url" => "..."}}}
```

Pass `fire_and_forget: true` to return immediately instead; the completed
artifact is delivered to your team's configured webhook.

List, fetch, delete, and refine artifacts:

```elixir
RevelryAI.Artifact.list_project_artifacts(1, "story")
RevelryAI.Artifact.get(123, "story")
RevelryAI.Artifact.delete(123, "story")

RevelryAI.Artifact.refine_artifact(%{
  artifact_id: 123,
  artifact_slug: "story",
  refine_prompt: "Make it shorter"
})
```

### Streaming (v1)

`stream_create_artifact/4` and `stream_refine_artifact/2` return an Elixir
stream that yields content chunks (strings) as they are generated, followed by
a final map containing the full response:

```elixir
"story"
|> RevelryAI.Artifact.stream_create_artifact(1, %{
  skill_id: 2,
  inputs: [%{name: "Context", value: "this is a test"}]
})
|> Enum.each(fn
  chunk when is_binary(chunk) -> IO.write(chunk)
  %{"response" => %{"artifact" => artifact}} -> IO.inspect(artifact["id"], label: "artifact id")
end)
```

### Data center

Upload a document to your team's data center for use in retrieval-augmented
generation:

```elixir
RevelryAI.DataCenter.upload_document("path/to/document.pdf")
```

### V2 API (async)

The v2 endpoints are asynchronous-only: they return immediately, and you
collect the result afterward. There are two completion mechanisms, depending
on the endpoint:

| Endpoint | Returns immediately with | Get the result via |
|---|---|---|
| `RevelryAI.V2.Skill.run/4` | `api_job_id` | polling `RevelryAI.V2.ApiJob` |
| `RevelryAI.V2.Artifact.create/3` | `api_async_create_event_id` | webhook |

#### Run a skill and poll for the result

`RevelryAI.V2.Skill.run/4` starts the skill and returns an `api_job_id`. The
job moves through `"pending"` → `"running"` → `"completed"` or `"failed"`.
`RevelryAI.V2.ApiJob.await/2` polls until the job reaches a terminal status:

```elixir
{:ok, %{response: %{"api_job_id" => api_job_id}}} =
  RevelryAI.V2.Skill.run(10, 1, %{
    inputs: [
      %{name: "Context", value: "this is a test"}
    ]
  })

case RevelryAI.V2.ApiJob.await(api_job_id, timeout: 300_000) do
  {:ok, %{response: %{"status" => "completed", "content" => content}}} ->
    content

  {:ok, %{response: %{"status" => "failed", "error_message" => message}}} ->
    {:error, message}

  {:error, :timeout} ->
    {:error, :timeout}

  {:error, reason} ->
    {:error, reason}
end
```

`await/2` accepts `interval` (time between polls, default 2,000 ms) and
`timeout` (overall deadline, default 120,000 ms); any other keys in the same
keyword list are treated as configuration overrides. Note that a failed job is
returned as `{:ok, ...}` — the poll succeeded — so branch on the job's
`"status"`.

To poll on your own schedule instead (e.g. from a GenServer or Oban job), use
`RevelryAI.V2.ApiJob.get/2` and check `"status"` yourself:

```elixir
{:ok, %{response: job}} = RevelryAI.V2.ApiJob.get(api_job_id)

job["status"]        #=> "pending" | "running" | "completed" | "failed"
job["content"]       #=> the generated output, once completed
job["error_message"] #=> the failure reason, if failed
```

#### Create an artifact asynchronously

`RevelryAI.V2.Artifact.create/3` returns an `api_async_create_event_id`. The
completed artifact is **not** available through `RevelryAI.V2.ApiJob` — it is
delivered to your team's configured webhook, whose payload includes the
`artifact_id`, `chat_id`, and the same `api_async_create_event_id` so you can
correlate it with your request:

```elixir
{:ok, %{response: %{"api_async_create_event_id" => event_id}}} =
  RevelryAI.V2.Artifact.create(1, %{
    skill_id: 10,
    inputs: [
      %{name: "Context", value: "this is a test"}
    ]
  })

# Store event_id; when the webhook arrives, match it to fetch the artifact:
RevelryAI.Artifact.get(artifact_id_from_webhook, "story")
```

### RevelryAI Definitions 
- Team: Synonymous with Company or Organization.  Teams can have one or many Users.  Teams can have details that define who they are, what they do, and what their culture represents.  Q: Are there constraints or limiters on Teams (e.g. domain) 
- Users: A member of a team.  A person who uses RevelryAI to create something.  Users are defined by email address and constrained by that email address to one Team.  
- Project: A software development (or other) project, product, or idea, generally defined with a goal.  A RevelryAI project could have a start and a finish, like a typical project (Build a wordpress marketing site for NOLA PD; Update the Revelry website with new creative and branding).  As well, a RevelryAI project could be an ongoing effort, such as a product (Platform, Peerbot, Apple Music).  At its most basic, a RevelryAI project is the subject that will drive the types of content that will be generated.  
- Artifact Types: Every piece of content generated in RevelryAI has a type, which determines the purpose, format, and skills used in generating the thing. Users define their own artifact types based on their needs.
- Skills: A re-usable definition of how content is generated, containing both dynamic and static data — a prompt with custom variables, document queries, and tool configuration. When the user is generating an artifact, this is what they will interact with, and that collaboration is what is sent to the LLM. Skills are grouped by the type of artifact selected.


## Contributing and Development

Bug reports and pull requests are welcome on GitHub at https://github.com/revelrylabs/revelry_ai_ex. Check out the [contributing guidelines](CONTRIBUTING.md) for more info.

Everyone is welcome to participate in the project. We expect contributors to adhere to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).

## Releases

See [RELEASES.md](RELEASES.md) for details about the release process.

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Docs can be found at <https://hexdocs.pm/revelry_ai>.

RevelryAI documentation can be found on the [help site](https://help.revelry.ai).

## License

RevelryAI is released under the MIT License. See the [LICENSE](LICENSE) file for details.
