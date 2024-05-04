defmodule ProdopsEx.Project do
  @moduledoc """
  Handles project operations for the ProdOps API.

  A Project is used for organization, and likely represents some real-world
  project, such as development of an application. Some resources can be
  Project-scoped. A Team may have multiple Projects.
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/projects"

  defp url(config) do
    config[:api_url] <> @base_path
  end

  @doc """
  Returns a list of all projects for a given team

  ## Parameters

  - `config` (optional): a configuration map used to override default config values

  ## Examples

      iex> ProdopsEx.Project.list()
      {:ok,
        %{
          status: "ok",
          response: %{
            "projects" => [
              %{
                "id" => 1,
                "name" => "Project Name",
                "overview" => "Project Overview"
              },
              %{
                "id" => 2,
                "name" => "Second Project",
                "overview" => "Second Project Overview"
              }
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
end
