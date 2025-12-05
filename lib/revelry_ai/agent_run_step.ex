defmodule RevelryAI.AgentRunStep do
  @moduledoc """
  Handles agent run step operations for the RevelryAI API.

  Agent run steps represent individual stages within an agent run. Steps may
  require user inputs to proceed and can produce artifact outputs.
  """
  alias RevelryAI.Client
  alias RevelryAI.Config

  @base_path "/api/v1/agents"

  defp url(config, agent_id, run_id) do
    config[:api_url] <> @base_path <> "/#{agent_id}/runs/#{run_id}/steps"
  end

  @doc """
  Retrieves a single agent run step by its ID.

  The response includes artifact output if available.

  ## Parameters

  - `agent_id`: the ID of the agent
  - `run_id`: the ID of the agent run
  - `step_id`: the ID of the step
  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> RevelryAI.AgentRunStep.get(1, 5, 10)
      {:ok,
        %{
          status: "ok",
          response: %{
            "agent_run_step" => %{
              "id" => 10,
              "status" => "waiting_for_input",
              "artifact" => %{
                "id" => 123,
                "content" => "Generated content..."
              }
            }
          }
        }
      }
  """
  @spec get(integer(), integer(), integer(), Keyword.t()) :: {:ok, map} | {:error, any}
  def get(agent_id, run_id, step_id, config \\ [])
      when is_integer(agent_id) and is_integer(run_id) and is_integer(step_id) do
    config = Config.resolve_config(config)
    endpoint = url(config, agent_id, run_id) <> "/#{step_id}"
    Client.api_get(endpoint, config)
  end

  @doc """
  Updates an agent run step, typically to provide user inputs.

  The artifact output (if available) is included in the response.

  ## Parameters

  - `agent_id`: the ID of the agent
  - `run_id`: the ID of the agent run
  - `step_id`: the ID of the step
  - `params`: the update parameters
    - `:user_inputs` - map of input variable names to values
  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> RevelryAI.AgentRunStep.update(1, 5, 10, %{
      ...>   user_inputs: %{
      ...>     "input_name" => "value",
      ...>     "document_input_name" => [1, 2, 3]
      ...>   }
      ...> })
      {:ok,
        %{
          status: "ok",
          response: %{
            "agent_run_step" => %{
              "id" => 10,
              "status" => "completed"
            }
          }
        }
      }
  """
  @spec update(integer(), integer(), integer(), map(), Keyword.t()) :: {:ok, map} | {:error, any}
  def update(agent_id, run_id, step_id, params, config \\ [])
      when is_integer(agent_id) and is_integer(run_id) and is_integer(step_id) and is_map(params) do
    config = Config.resolve_config(config)
    endpoint = url(config, agent_id, run_id) <> "/#{step_id}"
    Client.api_patch(endpoint, params, config)
  end
end
