defmodule RevelryAI.ConfigTest do
  use ExUnit.Case

  alias RevelryAI.Config

  doctest RevelryAI.Config

  describe "resolve_config/1" do
    test "it uses default values" do
      config = Config.resolve_config(api_key: "some api key")

      assert config[:api_url] == "https://app.revelry.ai"
      assert config[:http_options] == [{:recv_timeout, 60_000}]
    end

    test "it overrides default values with passed-in config" do
      config = Config.resolve_config(api_key: "some api key", http_options: [recv_timeout: 1], api_url: "someurl")

      assert config[:api_url] == "someurl"
      assert config[:http_options] == [{:recv_timeout, 1}]
    end

    test "it fails with invalid config" do
      assert_raise NimbleOptions.ValidationError, fn -> Config.resolve_config(api_key: 1) end

      assert_raise NimbleOptions.ValidationError, fn ->
        Config.resolve_config(api_key: "some api key", bad_option: "https://app.revelry.ai")
      end
    end
  end
end
