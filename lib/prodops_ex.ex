defmodule ProdopsEx do
  @moduledoc """
  Documentation for `ProdopsEx`.
  """

  alias ProdopsEx.Artifacts
  alias ProdopsEx.ArtifactType
  alias ProdopsEx.PromptTemplate
  alias ProdopsEx.Project
  alias ProdopsEx.Validate

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
  Retrieves prompt templates for a given artifact type.

  ## Parameters

  - `params`: The parameters for the artifact request.
  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example
  ```
  ProdopsEx.get_prompt_templates_for_artifact_type(
    %{artifact_type_slug: "story"},
    %ProdopsEx.Config{
      bearer_token: "your_api_key_here",
    }
  )
  ```
  """
  def get_prompt_templates_for_artifact_type(params, config) do
    PromptTemplate.get_prompt_templates_for_artifact_type(params, config)
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
end
