defmodule RevelryAI.AgentRunTest do
  use ExUnit.Case, async: true
  use Mimic

  alias RevelryAI.AgentRun
  alias RevelryAI.Client

  describe "list/3" do
    test "returns a list of agent runs for a given agent" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      agent_id = 1
      full_url = "#{api_url}/api/v1/agents/#{agent_id}/runs"

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "agent_runs" => [
               %{"id" => 1, "status" => "completed"}
             ]
           }
         }}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert AgentRun.list(agent_id, [], api_url: api_url, api_key: api_key) == response
    end

    test "includes query parameters when provided" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      agent_id = 1
      full_url = "#{api_url}/api/v1/agents/#{agent_id}/runs?project_id=5&limit=10&offset=20"

      response = {:ok, %{status: "ok", response: %{"agent_runs" => []}}}

      expect(Client, :api_get, fn ^full_url, _config -> response end)

      assert AgentRun.list(agent_id, [project_id: 5, limit: 10, offset: 20],
               api_url: api_url,
               api_key: api_key
             ) == response
    end
  end

  describe "create/3" do
    test "creates a new agent run without user inputs" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      agent_id = 1
      full_url = "#{api_url}/api/v1/agents/#{agent_id}/runs"
      params = %{project_id: 1}

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "agent_run" => %{"id" => 1, "status" => "running"}
           }
         }}

      expect(Client, :api_post, fn ^full_url, ^params, _config -> response end)
      assert AgentRun.create(agent_id, params, api_url: api_url, api_key: api_key) == response
    end

    test "creates a new agent run with user inputs" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      agent_id = 1
      full_url = "#{api_url}/api/v1/agents/#{agent_id}/runs"

      params = %{
        project_id: 1,
        user_inputs: %{
          "Generate Story" => %{
            "story_topic" => "A tale of adventure"
          }
        }
      }

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "agent_run" => %{"id" => 1, "status" => "running"}
           }
         }}

      expect(Client, :api_post, fn ^full_url, ^params, _config -> response end)
      assert AgentRun.create(agent_id, params, api_url: api_url, api_key: api_key) == response
    end
  end

  describe "get/3" do
    test "returns a single agent run by id" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      agent_id = 1
      run_id = 5
      full_url = "#{api_url}/api/v1/agents/#{agent_id}/runs/#{run_id}"

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "agent_run" => %{"id" => 5, "status" => "running"}
           }
         }}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert AgentRun.get(agent_id, run_id, api_url: api_url, api_key: api_key) == response
    end
  end

  describe "cancel/3" do
    test "cancels a running agent run" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      agent_id = 1
      run_id = 5
      full_url = "#{api_url}/api/v1/agents/#{agent_id}/runs/#{run_id}/cancel"

      response =
        {:ok,
         %{
           status: "ok",
           response: %{"message" => "Agent run cancelled"}
         }}

      expect(Client, :api_post, fn ^full_url, %{}, _config -> response end)
      assert AgentRun.cancel(agent_id, run_id, api_url: api_url, api_key: api_key) == response
    end
  end
end
