defmodule RevelryAI.Agent do
  @moduledoc """
  Handles agent operations for the RevelryAI API.

  Agents are automated workflows that can execute multiple steps to accomplish
  complex tasks. Each agent can have multiple runs, and each run progresses
  through a series of steps.
  """
  alias RevelryAI.Client
  alias RevelryAI.Config

  @base_path "/api/v1/agents"

  defp url(config) do
    config[:api_url] <> @base_path
  end

  @doc """
  Returns a list of all agents for your team.

  ## Parameters

  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> RevelryAI.Agent.list()
      {:ok,
        %{
          status: "ok",
          response: %{
            "agents" => [
              %{
                "id" => 1,
                "name" => "Story Generator"
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

  @doc """
  Retrieves a single agent by its ID.

  ## Parameters

  - `agent_id`: the ID of the agent
  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> RevelryAI.Agent.get(1)
      {:ok,
        %{
          status: "ok",
          response: %{
            "agent" => %{
              "id" => 1,
              "name" => "Story Generator"
            }
          }
        }
      }
  """
  @spec get(integer(), Keyword.t()) :: {:ok, map} | {:error, any}
  def get(agent_id, config \\ []) when is_integer(agent_id) do
    config = Config.resolve_config(config)
    endpoint = url(config) <> "/#{agent_id}"
    Client.api_get(endpoint, config)
  end
end
