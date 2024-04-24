defmodule ProdopsEx.Artifact do
  @moduledoc """
  Handles artifact operations for the ProdOps API such as retrieving artifacts for a given project, creating artifacts, refining artifacts, and deleting artifacts.
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/artifact_types"

  def url(%{project_id: project_id, artifact_slug: artifact_slug}, %Config{} = config) do
    config.api_url <> @base_path <> "/#{artifact_slug}/artifacts?project_id=#{project_id}"
  end

  defp url(%Config{} = config) do
    config.api_url <> @base_path
  end

  @doc """
  Retrieves artifacts for a given project.

  ## Parameters

  - `params`: The parameters for the artifact request.
  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example

      iex> ProdopsEx.get_artifacts_for_project(%{project_id: 1, artifact_slug: "story"}, %ProdopsEx.Config{bearer_token: "your_api_key_here"})
      {:ok,
        %{
          status: "ok",
          response: %{
            "artifacts" => [
              %{
                "chat_history" => [
                  %{
                    "content" => "You are going to be a product manager and write a BDD-style user story...",
                    "role" => "user"
                  },
                  ...
                ],
                "content" => "## Background ...",
                "id" => 1,
                "manually_edited" => false,
                "name" => "Artifact Name",
                "notes" => nil,
                "share_token" => nil
              },
              ...
            ]
          }
        }}

  ## Returns
  The function should return a list of artifacts for the specified project.
  """
  @spec get_artifacts_for_project(map, %Config{}) :: {:ok, list} | {:error, any}
  def get_artifacts_for_project(%{artifact_slug: artifact_slug, project_id: project_id} = _params, %Config{} = config) do
    endpoint = url(config)
    path = "/#{artifact_slug}/artifacts?project_id=#{project_id}"
    Client.api_get(endpoint <> path, config)
  end

  @doc """
  Creates an artifact by submitting a request with the required parameters.

  ## Parameters

    - `params`: The parameters for the artifact request.
    - `config`: The configuration map containing the API key and optionally the URL.

  ## Examples

      iex> ProdopsEx.Artifacts.create_artifact(%ProdopsEx.Config{
      ...>   bearer_token: "your_api_key_here"
      ...> }, %{
      ...>   prompt_template_id: 2,
      ...>   artifact_slug: "story",
      ...>   inputs: [
      ...>     %{name: "Context", value: "this is a test"}
      ...>   ],
      ...>   fire_and_forget: true
      ...> })
      {:ok, %{"artifact_id" => 123, "status" => "created"}}
  """
  @spec create_artifact(
          %{
            prompt_template_id: integer(),
            artifact_slug: String.t(),
            project_id: integer(),
            inputs: list(),
            fire_and_forget: boolean()
          },
          %Config{}
        ) :: {:ok, map()} | {:error, term()}
  def create_artifact(
        %{prompt_template_id: prompt_template_id, artifact_slug: artifact_slug, project_id: project_id} = params,
        %Config{} = config
      ) do
    url = url(config)
    path = "/#{artifact_slug}/artifacts?project_id=#{project_id}"
    fire_and_forget = Map.get(params, :fire_and_forget, false)
    inputs = Map.get(params, :inputs, [])
    body = %{prompt_template_id: prompt_template_id, inputs: inputs, fire_and_forget: fire_and_forget}
    Client.api_post(url <> path, body, config)
  end

  @doc """
  Retrieves an artifact by its ID.

  ## Parameters

  - `params`: The parameters for the artifact request.
  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example

      iex> ProdopsEx.get_artifact_by_id(%{artifact_slug: "story", artifact_id: 1}, %ProdopsEx.Config{bearer_token: "your_api_key_here"})
      {:ok,

        }
  """
  @spec get_artifact_by_id(map, %Config{}) :: {:ok, map} | {:error, any}
  def get_artifact_by_id(params, %Config{} = config) do
    %{artifact_slug: artifact_slug, artifact_id: artifact_id} = params
    endpoint = url(config) <> "/#{artifact_slug}/artifacts/#{artifact_id}"
    Client.api_get(endpoint, config)
  end

  @doc """
  Deletes an artifact by its ID.

  ## Parameters

  - `params`: The parameters for the artifact delete request.
  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example

      iex> ProdopsEx.delete_artifact_by_id(%{artifact_slug: "story", artifact_id: 1}, %ProdopsEx.Config{bearer_token: "your_api_key_here"})
      {:ok,
        %{status: "ok", response: %{"message" => "Artifact deleted successfully."}}}
  """
  @spec delete_artifact_by_id(map, %Config{}) :: {:ok, map} | {:error, any}
  def delete_artifact_by_id(params, %Config{} = config) do
    %{artifact_slug: artifact_slug, artifact_id: artifact_id} = params
    endpoint = url(config) <> "/#{artifact_slug}/artifacts/#{artifact_id}"
    Client.api_delete(endpoint, config)
  end
end
defmodule ProdopsEx.Artifact do
  @moduledoc """
  Handles artifact operations for the ProdOps API such as retrieving artifacts for a given project, creating artifacts, refining artifacts, and deleting artifacts.
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/artifact_types/"

  defp url(%{project_id: project_id, artifact_slug: artifact_slug}, %Config{} = config) do
    config.api_url <> @base_path <> "/#{artifact_slug}/artifacts?project_id=#{project_id}"
  end

  @doc """
  Retrieves artifacts for a given project.

  ## Parameters

  - `params`: The parameters for the artifact request.
  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example

      iex> ProdopsEx.get_artifacts_for_project(%{project_id: 1, artifact_slug: "story"}, %ProdopsEx.Config{bearer_token: "your_api_key_here"})
      {:ok,
        %{
          status: "ok",
          response: %{
            "artifacts" => [
              %{
                "chat_history" => [
                  %{
                    "content" => "You are going to be a product manager and write a BDD-style user story...",
                    "role" => "user"
                  },
                  ...
                ],
                "content" => "## Background ...",
                "id" => 1,
                "manually_edited" => false,
                "name" => "Artifact Name",
                "notes" => nil,
                "share_token" => nil
              },
              ...
            ]
          }
        }}

  ## Returns
  The function should return a list of artifacts for the specified project.
  """
  @spec get_artifacts_for_project(map, %Config{}) :: {:ok, list} | {:error, any}
  def get_artifacts_for_project(params, %Config{} = config) do
    endpoint = url(params, config)
    Client.api_get(endpoint, [], config)
  end

  @doc """
  Creates an artifact by submitting a request with the required parameters.

  ## Parameters

    - `prompt_template_id`: id of the prompt template.
    - `project_id`: id of the project.
    - `slug`: slug of the artifact type.
    - `inputs`: A list of custom input fields, each with `name` and `value`.
    - `fire_and_forget` (optional): Flag indicating whether to generate the artifact in the background without waiting for a response.

  ## Examples

      iex> ProdopsEx.Artifacts.create_artifact(%ProdopsEx.Config{
      ...>   bearer_token: "your_api_key_here"
      ...> }, %{
      ...>   prompt_template_id: 2,
      ...>   inputs: [
      ...>     %{name: "Context", value: "this is a test"}
      ...>   ],
      ...>   fire_and_forget: true
      ...> })
      {:ok, %{"artifact_id" => 123, "status" => "created"}}
  """
  @spec create_artifact(
          Config.t(),
          %{prompt_template_id: integer(), slug: String.t(), project_id: integer(), inputs: list()}
        ) :: {:ok, map()} | {:error, term()}
  def create_artifact(
        %Config{} = config,
        %{prompt_template_id: prompt_template_id, slug: slug, project_id: project_id} = params
      ) do
    path = "/api/v1/artifact_types/#{slug}/artifacts?project_id=#{project_id}"
    url = url(params, config)
    inputs = Map.get(params, :inputs, [])
    body = %{prompt_template_id: prompt_template_id, inputs: inputs}

    Client.api_post(url, body, config)
  end
end
