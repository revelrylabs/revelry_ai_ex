defmodule RevelryAI.ModelConfigurationTest do
  use ExUnit.Case, async: true
  use Mimic

  alias RevelryAI.Client
  alias RevelryAI.ModelConfiguration

  describe "list/1" do
    test "returns a list of all enabled model configurations" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      full_url = "#{api_url}/api/v1/model_configurations"

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "model_configurations" => [
               %{
                 "id" => 1,
                 "name" => "gpt-4o",
                 "provider" => "open_ai",
                 "friendly_name" => "GPT-4o",
                 "enabled" => true
               }
             ]
           }
         }}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert ModelConfiguration.list(api_url: api_url, api_key: api_key) == response
    end
  end

  describe "get/2" do
    test "returns a single model configuration by id" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      model_config_id = 1
      full_url = "#{api_url}/api/v1/model_configurations/#{model_config_id}"

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "model_configuration" => %{
               "id" => 1,
               "name" => "gpt-4o",
               "provider" => "open_ai",
               "friendly_name" => "GPT-4o",
               "enabled" => true
             }
           }
         }}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert ModelConfiguration.get(model_config_id, api_url: api_url, api_key: api_key) == response
    end
  end
end
