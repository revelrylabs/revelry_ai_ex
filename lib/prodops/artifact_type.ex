defmodule ProdopsEx.ArtifactType do
  @moduledoc """
  Handles artifact type operations for the ProdOps API.

  These represent types of outputs. They may be things like user stories, code
  snippets, blog posts, or anything else that has been defined within the
  ProdOps UI. They are used to classify generated Artifacts into groups.
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/artifact_types"

  @doc """
  Returns a list of all artifact types for a given team

  ## Examples

      iex> ProdopsEx.ArtifactType.list()
      {:ok,
        %{
          status: "ok",
          response: %{
            "artifact_types" => [
              %{
                "description" => "This is a story",
                "name" => "Story",
                "slug" => "story"
              },
              ...
            ]
          }
        }
      }
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
