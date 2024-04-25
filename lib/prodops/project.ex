defmodule ProdopsEx.Project do
  @moduledoc """
  Handles project operations for the ProdOps API.
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/projects"

  @doc """
  Returns a list of all projects for a given team

  ## Examples

      iex> ProdopsEx.Project.list(%ProdopsEx.Config{bearer_token: "your_api_key_here"})
      {:ok, %{status: "ok", response: %{ "projects": [
            {
              "id": 1,
              "name": "ProdOps",
              "overview": "This is the project overview"
            }
        ]}}}
  """
  @spec list(%Config{}) :: {:ok, map} | {:error, any}
  def list(%Config{} = config) do
    Client.api_get(url(config), config)
  end

  defp url(%Config{} = config) do
    config.api_url <> @base_path
  end
end
