defmodule ProdopsEx do
  @moduledoc """
  Documentation for `ProdopsEx`.
  """

  alias ProdopsEx.ArtifactType
  alias ProdopsEx.Validate
  alias ProdopsEx.Artifacts

  @doc """
  Validates the provided API key and return team information.

  ## Parameters

  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example
  ```elixir
  ProdopsEx.validate(
    %ProdopsEx.Config{
      bearer_token: "your_api_key_here",
    }
  )
  ```

  ## Returns
  {:ok, %{status: "ok", response: %{"team_id" => 1, "team_name" => "ProdOps"}}}
  """
  def validate_api_key(config) do
    Validate.validate_api_key(config)
  end

  @doc """
  Retrieves artifacts for a given project.

  ## Parameters

  - `params`: The parameters for the artifact request.
  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example
  ```
  ProdopsEx.get_artifacts_for_project(
    %{project_id: 212, artifact_slug: "story"},
    %ProdopsEx.Config{
      bearer_token: "your_api_key_here",
    }
  )
  ```
  """
  def get_artifacts_for_project(params, config) do
    Artifacts.get_artifacts_for_project(params, config)
  end

  @doc """
  Returns a list of all artifact types for a given team

  ## Parameters

  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example
  ```elixir
  ProdopsEx.list_artifact_types(
    %ProdopsEx.Config{
      bearer_token: "your_api_key_here",
    }
  )
  ```

  ## Returns
  {:ok, %{status: "ok", response: %{ "artifact_types": [
            {
                "slug": "story",
                "name": "Story",
                "description": "This is a story"
            }
  ]}}}
  """
  def list_artifact_types(config) do
    ArtifactType.list(config)
  end
end
