defmodule RevelryAI.V2.ArtifactTest do
  use ExUnit.Case, async: true
  use Mimic

  alias RevelryAI.Client
  alias RevelryAI.V2.Artifact

  setup do
    %{
      config: [
        http_options: [recv_timeout: 60_000],
        api_url: "https://api.example.com",
        api_key: "secret_key"
      ],
      project_id: 1,
      inputs: [%{name: "Context", value: "this is a test"}]
    }
  end

  describe "create/2" do
    test "creates an artifact with a skill_id", %{config: config, project_id: project_id, inputs: inputs} do
      params = %{skill_id: 10, project_id: project_id, inputs: inputs}
      full_url = "#{config[:api_url]}/api/v2/artifacts?project_id=#{project_id}"

      response =
        {:ok,
         %{
           status: "ok",
           response: %{"api_async_create_event_id" => "some-uuid", "message" => "Artifact is being generated."}
         }}

      expect(Client, :api_post, fn ^full_url, body, ^config ->
        assert body == %{skill_id: 10, inputs: inputs}
        response
      end)

      assert Artifact.create(params, config) == response
    end

    test "creates an artifact with a deprecated prompt_template_id and optional params", %{
      config: config,
      project_id: project_id,
      inputs: inputs
    } do
      params = %{
        prompt_template_id: 2,
        project_id: project_id,
        inputs: inputs,
        name: "My Artifact",
        model_configuration_id: 5
      }

      full_url = "#{config[:api_url]}/api/v2/artifacts?project_id=#{project_id}"

      response = {:ok, %{status: "ok", response: %{"api_async_create_event_id" => "some-uuid"}}}

      expect(Client, :api_post, fn ^full_url, body, ^config ->
        assert body == %{prompt_template_id: 2, inputs: inputs, name: "My Artifact", model_configuration_id: 5}
        response
      end)

      assert Artifact.create(params, config) == response
    end

    test "raises when neither skill_id nor prompt_template_id is given", %{
      config: config,
      project_id: project_id,
      inputs: inputs
    } do
      assert_raise FunctionClauseError, fn ->
        Artifact.create(%{project_id: project_id, inputs: inputs}, config)
      end
    end

    test "raises when inputs are missing", %{config: config, project_id: project_id} do
      assert_raise FunctionClauseError, fn ->
        Artifact.create(%{skill_id: 10, project_id: project_id}, config)
      end
    end
  end
end
