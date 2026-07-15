defmodule RevelryAI.V2.SkillTest do
  use ExUnit.Case, async: true
  use Mimic

  alias RevelryAI.Client
  alias RevelryAI.V2.Skill

  setup do
    %{
      config: [
        http_options: [recv_timeout: 60_000],
        api_url: "https://api.example.com",
        api_key: "secret_key"
      ],
      skill_id: 10,
      project_id: 1,
      inputs: [%{name: "Context", value: "this is a test"}]
    }
  end

  describe "run/4" do
    test "runs a skill asynchronously", %{
      config: config,
      skill_id: skill_id,
      project_id: project_id,
      inputs: inputs
    } do
      params = %{inputs: inputs}
      full_url = "#{config[:api_url]}/api/v2/skills/#{skill_id}/run?project_id=#{project_id}"

      response = {:ok, %{status: "ok", response: %{"api_job_id" => 42, "message" => "Skill execution started."}}}

      expect(Client, :api_post, fn ^full_url, ^params, ^config -> response end)

      assert Skill.run(skill_id, project_id, params, config) == response
    end

    test "passes params through as the body verbatim", %{
      config: config,
      skill_id: skill_id,
      project_id: project_id,
      inputs: inputs
    } do
      params = %{inputs: inputs, model_configuration_id: 5}
      full_url = "#{config[:api_url]}/api/v2/skills/#{skill_id}/run?project_id=#{project_id}"

      expect(Client, :api_post, fn ^full_url, ^params, ^config ->
        {:ok, %{status: "ok", response: %{"api_job_id" => 42}}}
      end)

      assert {:ok, _} = Skill.run(skill_id, project_id, params, config)
    end

    test "raises when skill_id is not an integer", %{config: config, project_id: project_id, inputs: inputs} do
      assert_raise FunctionClauseError, fn ->
        Skill.run("10", project_id, %{inputs: inputs}, config)
      end
    end

    test "raises when inputs are missing", %{config: config, skill_id: skill_id, project_id: project_id} do
      assert_raise FunctionClauseError, fn ->
        Skill.run(skill_id, project_id, %{}, config)
      end
    end
  end
end
