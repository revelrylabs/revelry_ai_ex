defmodule ProdopsEx do
  @moduledoc """
  Documentation for `ProdopsEx`.
  """

  alias ProdopsEx.Artifact
  alias ProdopsEx.ArtifactType
  alias ProdopsEx.Project
  alias ProdopsEx.PromptTemplate
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
    Artifact.delete_artifact_by_id(params, config)
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
    Artifact.get_artifacts_for_project(params, config)
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
    Artifact.get_artifact_by_id(params, config)
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
  Creates an artifact.

  ## Parameters

  - `config`: The configuration map containing the API key and any other configuration values.
  - `params`: The parameters for the artifact request.

  ## Example
  ```
  ProdopsEx.create_artifact(
    %ProdopsEx.Config{
      bearer_token: "your_api_key_here",
    }
    %{
      project_id: 123,
      slug: "story",
      prompt_template_id: 123,
      inputs: [
        %{name: "Input", value: "Value"}
      ]}
  )
  ```
  """
  def create_artifact(params, config) do
    Artifact.create_artifact(params, config)
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
