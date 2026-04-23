defmodule RevelryAI.AgentRun do
  @moduledoc """
  Handles agent run operations for the RevelryAI API.

  An agent run represents a single execution of an agent. Runs progress through
  multiple steps and can be provided with user inputs at creation or during
  execution.
  """
  alias RevelryAI.Client
  alias RevelryAI.Config

  @base_path "/api/v1/agents"

  defp url(config, agent_id) do
    config[:api_url] <> @base_path <> "/#{agent_id}/runs"
  end

  @doc """
  Returns a list of agent runs for a given agent.

  ## Parameters

  - `agent_id`: the ID of the agent
  - `opts`: optional parameters for filtering and pagination
    - `:project_id` - filter by project ID
    - `:limit` - number of results to return (default: 20)
    - `:offset` - number of results to skip (default: 0)
  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> RevelryAI.AgentRun.list(1)
      {:ok,
        %{
          status: "ok",
          response: %{
            "agent_runs" => [
              %{
                "id" => 1,
                "status" => "completed"
              }
            ]
          }
        }
      }

      iex> RevelryAI.AgentRun.list(1, project_id: 5, limit: 10)
      {:ok, %{...}}
  """
  @spec list(integer(), Keyword.t(), Keyword.t()) :: {:ok, map} | {:error, any}
  def list(agent_id, opts \\ [], config \\ []) when is_integer(agent_id) do
    config = Config.resolve_config(config)
    query_string = build_query_string(opts)
    endpoint = url(config, agent_id) <> query_string
    Client.api_get(endpoint, config)
  end

  @doc """
  Creates a new agent run for the given agent.

  ## Parameters

  - `agent_id`: the ID of the agent
  - `params`: the parameters for the agent run
    - `:project_id` (required) - the project ID
    - `:user_inputs` (optional) - map of step names to input variable maps
  - `config` (optional): a configuration map used to override default config values

  ## Examples

      # Without initial inputs
      iex> RevelryAI.AgentRun.create(1, %{project_id: 1})
      {:ok, %{...}}

      # With initial inputs
      iex> RevelryAI.AgentRun.create(1, %{
      ...>   project_id: 1,
      ...>   user_inputs: %{
      ...>     "Generate Story" => %{
      ...>       "story_topic" => "A tale of adventure",
      ...>       "document_ids" => [1, 2, 3]
      ...>     }
      ...>   }
      ...> })
      {:ok, %{...}}
  """
  @spec create(integer(), map(), Keyword.t()) :: {:ok, map} | {:error, any}
  def create(agent_id, params, config \\ []) when is_integer(agent_id) and is_map(params) do
    config = Config.resolve_config(config)
    endpoint = url(config, agent_id)
    Client.api_post(endpoint, params, config)
  end

  @doc """
  Retrieves a single agent run by its ID.

  ## Parameters

  - `agent_id`: the ID of the agent
  - `run_id`: the ID of the agent run
  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> RevelryAI.AgentRun.get(1, 5)
      {:ok,
        %{
          status: "ok",
          response: %{
            "agent_run" => %{
              "id" => 5,
              "status" => "running"
            }
          }
        }
      }
  """
  @spec get(integer(), integer(), Keyword.t()) :: {:ok, map} | {:error, any}
  def get(agent_id, run_id, config \\ []) when is_integer(agent_id) and is_integer(run_id) do
    config = Config.resolve_config(config)
    endpoint = url(config, agent_id) <> "/#{run_id}"
    Client.api_get(endpoint, config)
  end

  @doc """
  Cancels a running agent run.

  ## Parameters

  - `agent_id`: the ID of the agent
  - `run_id`: the ID of the agent run to cancel
  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> RevelryAI.AgentRun.cancel(1, 5)
      {:ok, %{status: "ok", response: %{"message" => "Agent run cancelled"}}}
  """
  @spec cancel(integer(), integer(), Keyword.t()) :: {:ok, map} | {:error, any}
  def cancel(agent_id, run_id, config \\ []) when is_integer(agent_id) and is_integer(run_id) do
    config = Config.resolve_config(config)
    endpoint = url(config, agent_id) <> "/#{run_id}/cancel"
    Client.api_post(endpoint, %{}, config)
  end

  defp build_query_string(opts) do
    params =
      []
      |> maybe_add_param(:project_id, opts[:project_id])
      |> maybe_add_param(:limit, opts[:limit])
      |> maybe_add_param(:offset, opts[:offset])

    case params do
      [] -> ""
      _ -> "?" <> Enum.join(params, "&")
    end
  end

  defp maybe_add_param(params, _key, nil), do: params
  defp maybe_add_param(params, key, value), do: params ++ ["#{key}=#{value}"]
end
