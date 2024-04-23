defmodule ProdopsEx.Artifacts do
  @moduledoc """
  Handles validation operations for the ProdOps API.
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
  The function should return a list of up to 5 artifacts for the specified project.
  """
  @spec get_artifacts_for_project(map, %Config{}) :: {:ok, list} | {:error, any}
  def get_artifacts_for_project(params, %Config{} = config) do
    endpoint = url(params, config)
    Client.api_get(endpoint, [], config)
  end

  defp url(%{project_id: project_id, artifact_slug: artifact_slug}, %Config{} = config) do
    config.api_url <> @base_path <> "/#{artifact_slug}/artifacts?project_id=#{project_id}"
  end
end
