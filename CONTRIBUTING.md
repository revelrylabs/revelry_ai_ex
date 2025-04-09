# Contributing and Development

## API Key

You'll need a [RevelryAI API key](https://help.revelry.ai/docs/api/get-your-api-token)
to get started. Copy `config/config.example-secret.exs` to
`config/config.secret.exs` and put your API key into that file.

## Development Setup

1. Make sure you have Elixir 1.12+ installed
1. Clone the repo
1. Run `mix deps.get`
1. Run `mix test`

You can run the same checks that are in the CI pipeline, which is run via GitHub Actions:

```
./presubmit.sh
```

For convenience we recommend using this as a pre-push hook:

```
cp presubmit.sh .git/hooks/pre-push
```

You can run the library via the `iex` shell to run functions through it, e.g.:

```
iex -S mix
iex()> RevelryAI.Artifact.get(123, "story")
```

## Submitting Changes

1. Find or open an Issue related to the changes you're making
1. Fork the project
1. Create a new topic branch to contain your feature, change, or fix.
1. Make sure all the checks are still passing: the CI system runs these checks automatically
1. Implement your feature, change, or fix. Make sure to write tests, update and/or add documentation.
1. Push your topic branch up to your fork.
1. Open a Pull Request with a clear title and description, and mention the related Issue(s)
