defmodule ProdopsEx do
  @moduledoc """
  Documentation for `ProdopsEx`.
  """

  alias ProdopsEx.Artifacts
  alias ProdopsEx.ArtifactType
  alias ProdopsEx.Project
  alias ProdopsEx.Validate

  @doc """
  Deletes an artifact by its ID.

  ## Parameters

  - `params`: The parameters for the artifact delete request.
  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example
  ```elixir
  ProdopsEx.delete_artifact_by_id(
    %{artifact_slug: "story", artifact_id: 1},
    %ProdopsEx.Config{
      bearer_token: "your_api_key_here",
    }
  )
  ```
  """
  def delete_artifact_by_id(params, config) do
    Artifacts.delete_artifact_by_id(params, config)
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
  Retrieves an artifact by its ID.

  ## Parameters

  - `params`: The parameters for the artifact request.
  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example
  ```elixir
  ProdopsEx.get_artifact_by_id(
    %{artifact_slug: "story", artifact_id: 1},
    %ProdopsEx.Config{
      bearer_token: "your_api_key_here",
    }
  )
  ```
  """
  def get_artifact_by_id(params, config) do
    Artifacts.get_artifact_by_id(params, config)
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

  @doc """
  Returns a list of all projects for a given team

  ## Parameters

  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example
  ```elixir
  ProdopsEx.list_projects(
    %ProdopsEx.Config{
      bearer_token: "your_api_key_here",
    }
  )
  ```

  ## Returns
  {:ok, %{status: "ok", response: %{ "projects": [
            {
              "id": 1,
              "name": "ProdOps",
              "overview": "This is the project overview"
            }
  ]}}}
  """
  def list_projects(config) do
    Project.list(config)
  end

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
end
