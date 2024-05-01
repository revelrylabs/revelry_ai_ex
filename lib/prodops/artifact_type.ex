defmodule ProdopsEx.ArtifactType do
  @moduledoc """
  Handles artifact type operations for the ProdOps API.
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/artifact_types"

  @doc """
  Returns a list of all artifact types for a given team

  ## Examples

      iex> ProdopsEx.ArtifactType.list()
      {:ok, %{status: "ok", response: %{ "artifact_types": [
            {
                "slug": "story",
                "name": "Story",
                "description": "This is a story"
            }
        ]}}}
  """
  @spec list(Keyword.t()) :: {:ok, map} | {:error, any}
  def list(config \\ []) do
    config = Config.resolve_config(config)
    Client.api_get(url(config), config)
  end

  defp url(config) do
    config[:api_url] <> @base_path
  end
end
