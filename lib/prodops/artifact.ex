defmodule ProdopsEx.Artifact do
  @moduledoc """
  Handles artifact operations for the ProdOps API such as retrieving artifacts for a given project, creating artifacts, refining artifacts, and deleting artifacts.
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/artifact_types"

  defp url(config) do
    config[:api_url] <> @base_path
  end

  @doc """
  Retrieves artifacts for a given project.

  ## Parameters

  - `params`: The parameters for the artifact request.
  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example

      iex> ProdopsEx.get_artifacts_for_project(%{project_id: 1, artifact_slug: "story"})
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
  @spec get_artifacts_for_project(map, Keyword.t()) :: {:ok, list} | {:error, any}
  def get_artifacts_for_project(%{artifact_slug: artifact_slug, project_id: project_id} = _params, config) do
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

      iex> ProdopsEx.Artifacts.create_artifact(%{
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
          Keyword.t()
        ) :: {:ok, map()} | {:error, term()}
  def create_artifact(
        %{prompt_template_id: prompt_template_id, artifact_slug: artifact_slug, project_id: project_id} = params,
        config
      ) do
    config = Config.resolve_config(config)
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

      iex> ProdopsEx.get_artifact_by_id(%{artifact_slug: "story", artifact_id: 1})
      {:ok,

        }
  """
  @spec get_artifact_by_id(map, Keyword.t()) :: {:ok, map} | {:error, any}
  def get_artifact_by_id(params, config) do
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

      iex> ProdopsEx.delete_artifact_by_id(%{artifact_slug: "story", artifact_id: 1})
      {:ok,
        %{status: "ok", response: %{"message" => "Artifact deleted successfully."}}}
  """
  @spec delete_artifact_by_id(map, Keyword.t()) :: {:ok, map} | {:error, any}
  def delete_artifact_by_id(params, config) do
    %{artifact_slug: artifact_slug, artifact_id: artifact_id} = params
    endpoint = url(config) <> "/#{artifact_slug}/artifacts/#{artifact_id}"
    Client.api_delete(endpoint, config)
  end

  @doc """
  Refines an artifact by submitting a request with the required parameters.

  ## Parameters
  - `params`: The parameters for the artifact request.
  - `config`: The configuration map containing the API key and optionally the URL.

  ## Example

      iex> ProdopsEx.Artifacts.refine_artifact(%{
      ...>   artifact_id: 1,
      ...>   artifact_slug: "story",
      ...>   refine_prompt: "Refine this story"
      ...> })
  """
  @spec refine_artifact(
          %{
            artifact_id: integer(),
            artifact_slug: String.t(),
            refine_prompt: String.t()
          },
          Keyword.t()
        ) :: {:ok, map} | {:error, any}
  def refine_artifact(%{artifact_slug: artifact_slug, artifact_id: artifact_id} = params, config) do
    url = url(config) <> "/#{artifact_slug}/artifacts/#{artifact_id}/refine"
    Client.api_post(url, params, config)
  end
end
