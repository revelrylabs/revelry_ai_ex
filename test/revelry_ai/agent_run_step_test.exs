defmodule RevelryAI.AgentRunStepTest do
  use ExUnit.Case, async: true
  use Mimic

  alias RevelryAI.AgentRunStep
  alias RevelryAI.Client

  describe "get/4" do
    test "returns a single agent run step by id" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      agent_id = 1
      run_id = 5
      step_id = 10
      full_url = "#{api_url}/api/v1/agents/#{agent_id}/runs/#{run_id}/steps/#{step_id}"

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "agent_run_step" => %{
               "id" => 10,
               "status" => "waiting_for_input",
               "artifact" => %{"id" => 123, "content" => "Generated content"}
             }
           }
         }}

      expect(Client, :api_get, fn ^full_url, _config -> response end)

      assert AgentRunStep.get(agent_id, run_id, step_id, api_url: api_url, api_key: api_key) ==
               response
    end
  end

  describe "update/5" do
    test "updates an agent run step with user inputs" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      agent_id = 1
      run_id = 5
      step_id = 10
      full_url = "#{api_url}/api/v1/agents/#{agent_id}/runs/#{run_id}/steps/#{step_id}"

      params = %{
        user_inputs: %{
          "input_name" => "value",
          "document_input_name" => [1, 2, 3]
        }
      }

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "agent_run_step" => %{
               "id" => 10,
               "status" => "completed"
             }
           }
         }}

      expect(Client, :api_patch, fn ^full_url, ^params, _config -> response end)

      assert AgentRunStep.update(agent_id, run_id, step_id, params,
               api_url: api_url,
               api_key: api_key
             ) == response
    end
  end
end
