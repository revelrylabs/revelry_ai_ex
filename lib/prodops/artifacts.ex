defmodule ProdopsEx.Artifacts do
  @moduledoc """
  Handles artifact operations for the ProdOps API such as retrieving artifacts for a given project, creating artifacts, refining artifacts, and deleting artifacts.
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/artifact_types/"

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
    %{artifact_slug: artifact_slug, project_id: project_id} = params
    endpoint = url(config) <> "/#{artifact_slug}/artifacts?project_id=#{project_id}"
    Client.api_get(endpoint, [], config)
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
    Client.api_get(endpoint, [], config)
  end

  defp url(%Config{} = config) do
    config.api_url <> @base_path
  end
end
