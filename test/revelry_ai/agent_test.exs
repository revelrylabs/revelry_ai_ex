defmodule RevelryAI.AgentTest do
  use ExUnit.Case, async: true
  use Mimic

  alias RevelryAI.Agent
  alias RevelryAI.Client

  describe "list/1" do
    test "returns a list of all agents for a given team" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      full_url = "#{api_url}/api/v1/agents"

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "agents" => [
               %{"id" => 1, "name" => "Story Generator"}
             ]
           }
         }}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert Agent.list(api_url: api_url, api_key: api_key) == response
    end
  end

  describe "get/2" do
    test "returns a single agent by id" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      agent_id = 1
      full_url = "#{api_url}/api/v1/agents/#{agent_id}"

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "agent" => %{"id" => 1, "name" => "Story Generator"}
           }
         }}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert Agent.get(agent_id, api_url: api_url, api_key: api_key) == response
    end
  end
end
