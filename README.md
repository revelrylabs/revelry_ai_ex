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

## Installation

Add RevelryAI to your mix.exs:

```elixir
def deps do
  [
    {:revelry_ai, "~> 0.2.0"}
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

Create a new artifact in RevelryAI

```elixir
params = %{
      prompt_template_id: 2,
      artifact_slug: "story",
      inputs: [
        %{name: "Context", value: "this is a test"}
      ],
      fire_and_forget: true
    }

artifact = RevelryAI.Artifact.create(params)
```

This will create a new artifact of the given artifact type for the given team matching the api token placed in the config. 

```elixir
{:ok, %{"artifact_id" => 123, "status" => "created"}}
```


### RevelryAI Definitions 
- Team: Synonymous with Company or Organization.  Teams can have one or many Users.  Teams can have details that define who they are, what they do, and what their culture represents.  Q: Are there constraints or limiters on Teams (e.g. domain) 
- Users: A member of a team.  A person who uses RevelryAI to create something.  Users are defined by email address and constrained by that email address to one Team.  
- Project: A software development (or other) project, product, or idea, generally defined with a goal.  A RevelryAI project could have a start and a finish, like a typical project (Build a wordpress marketing site for NOLA PD; Update the Revelry website with new creative and branding).  As well, a RevelryAI project could be an ongoing effort, such as a product (Platform, Peerbot, Apple Music).  At its most basic, a RevelryAI project is the subject that will drive the types of content that will be generated.  
- Artifact Types: Every piece of content generated in RevelryAI has a type, which determines the purpose, format, and types of prompt used in generating the thing. Users define their own prompt template types based on their needs.
- Prompt templates / Prompt / Template: A re-usable template that contains both dynamic and static data. When the user is generating an artifact, this is what they will interact with, and that collaboration is what is sent to the LLM. Prompt templates are grouped by the type of artifact selected.


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
