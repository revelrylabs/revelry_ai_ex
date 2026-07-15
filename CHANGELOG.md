# Changelog

## 0.3.0

### Breaking changes

Prompt templates are replaced by skills throughout the SDK, matching the
RevelryAI API (where `prompt_template_id` has been deprecated in favor of
`skill_id`). Function signatures also changed so that path/query values are
positional arguments and the params map is exactly the request body.

- `RevelryAI.PromptTemplate` is removed. Use `RevelryAI.Skill.list/2`, which
  calls the current `/skills` endpoint and returns skills instead of prompt
  templates.
- `RevelryAI.Artifact.create/2` is now `RevelryAI.Artifact.create/4` and takes
  `skill_id` instead of `prompt_template_id`:

  ```elixir
  # before (0.2.x)
  RevelryAI.Artifact.create(%{
    prompt_template_id: 2,
    artifact_slug: "story",
    project_id: 1,
    inputs: [%{name: "Context", value: "test"}]
  })

  # after (0.3.0) — the skill_id replaces the prompt_template_id
  RevelryAI.Artifact.create("story", 1, %{
    skill_id: 2,
    inputs: [%{name: "Context", value: "test"}]
  })
  ```

  Skill IDs are not interchangeable with prompt template IDs — look up the new
  ID with `RevelryAI.Skill.list/2`.
- `RevelryAI.Artifact.stream_create_artifact/2` is now
  `stream_create_artifact/4` with the same signature change as `create/4`.

### Added

- V2 API support (async-only endpoints):
  - `RevelryAI.V2.Artifact.create/3` — create an artifact asynchronously;
    completion is delivered via webhook.
  - `RevelryAI.V2.Skill.run/4` — run a skill without creating an artifact.
  - `RevelryAI.V2.ApiJob.get/2` and `RevelryAI.V2.ApiJob.await/2` — poll async
    job results.
- V1 `Artifact.create/4` now passes through optional `name` and
  `model_configuration_id` params.

### Fixed

- `RevelryAI.Client` treated only HTTP 200 as success; any 2xx (e.g. the 202
  returned by v2 endpoints) is now handled as success.

## 0.2.0 and earlier

See the [GitHub releases](https://github.com/revelrylabs/revelry_ai_ex/releases).
