defmodule RevelryAI.SkillTest do
  use ExUnit.Case, async: true
  use Mimic

  alias RevelryAI.Client
  alias RevelryAI.Skill

  setup do
    %{
      config: [
        http_options: [recv_timeout: 60_000],
        api_url: "https://api.example.com",
        api_key: "secret_key"
      ],
      artifact_slug: "story"
    }
  end

  describe "list/2" do
    test "returns a list of skills for a given artifact type", %{config: config, artifact_slug: artifact_slug} do
      full_url = "#{config[:api_url]}/api/v1/artifact_types/#{artifact_slug}/skills"

      response =
        {:ok, %{status: "ok", response: %{"skills" => [%{"id" => 1, "name" => "Question Answering"}]}}}

      expect(Client, :api_get, fn ^full_url, ^config -> response end)
      assert Skill.list(artifact_slug, config) == response
    end

    test "raises when artifact_slug is not a string", %{config: config} do
      assert_raise FunctionClauseError, fn ->
        Skill.list(123, config)
      end
    end
  end
end
