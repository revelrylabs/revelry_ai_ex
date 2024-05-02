defmodule ProdopsEx.ArtifactTest do
  use ExUnit.Case, async: true
  use Mimic

  alias ProdopsEx.Artifact
  alias ProdopsEx.Client

  describe "list_project_artifacts/3" do
    test "returns a list of artifacts for a given project and artifact type" do
      config = [api_url: "https://api.example.com", api_key: "secret_key"]
      project_id = 1
      artifact_slug = "story"
      full_url = "#{config[:api_url]}/api/v1/artifact_types/#{artifact_slug}/artifacts?project_id=#{project_id}"

      response = {:ok, %{"status" => "ok", "response" => %{"artifacts" => [%{"id" => 1, "name" => "Artifact Name"}]}}}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert Artifact.list_project_artifacts(project_id, artifact_slug, config) == response
    end
  end

  describe "create/2" do
    test "creates an artifact with the given parameters" do
      config = [
        http_options: [recv_timeout: 60_000],
        api_url: "https://api.example.com",
        api_key: "secret_key"
      ]

      params = %{
        prompt_template_id: 2,
        inputs: [%{name: "Context", value: "this is a test"}],
        fire_and_forget: true,
        artifact_slug: "story",
        project_id: 1
      }

      full_url = "#{config[:api_url]}/api/v1/artifact_types/story/artifacts?project_id=1"

      response = {:ok, %{"artifact_id" => 123, "status" => "created"}}

      expect(Client, :api_post, fn url, _body, opts ->
        assert url == full_url
        assert opts == config
        response
      end)

      assert Artifact.create(params, config) == response
    end
  end

  describe "get/3" do
    test "retrieves an artifact by its ID" do
      config = [api_url: "https://api.example.com", api_key: "secret_key"]
      artifact_id = 1
      artifact_slug = "story"
      full_url = "#{config[:api_url]}/api/v1/artifact_types/#{artifact_slug}/artifacts/#{artifact_id}"

      response = {:ok, %{"id" => artifact_id, "name" => "Artifact Name"}}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert Artifact.get(artifact_id, artifact_slug, config) == response
    end
  end

  describe "delete/3" do
    test "deletes an artifact by its ID" do
      config = [api_url: "https://api.example.com", api_key: "secret_key"]
      artifact_id = 1
      artifact_slug = "story"
      full_url = "#{config[:api_url]}/api/v1/artifact_types/#{artifact_slug}/artifacts/#{artifact_id}"

      response = {:ok, %{"status" => "ok", "response" => %{"message" => "Artifact deleted successfully."}}}

      expect(Client, :api_delete, fn ^full_url, _config -> response end)
      assert Artifact.delete(artifact_id, artifact_slug, config) == response
    end
  end

  describe "refine_artifact/2" do
    test "refines an artifact by submitting a request with the required parameters" do
      config = [api_url: "https://api.example.com", api_key: "secret_key"]
      params = %{artifact_id: 1, artifact_slug: "story", refine_prompt: "Refine this story"}
      full_url = "#{config[:api_url]}/api/v1/artifact_types/story/artifacts/1/refine"

      response = {:ok, %{"status" => "ok", "response" => %{"message" => "Artifact refined successfully."}}}

      expect(Client, :api_post, fn ^full_url, ^params, _config -> response end)
      assert Artifact.refine_artifact(params, config) == response
    end
  end

  describe "stream_refine_artifact/2" do
    test "streams refinement of an artifact by submitting a request with the required parameters" do
      config = [api_url: "https://api.example.com", api_key: "secret_key"]
      params = %{artifact_id: 1, artifact_slug: "story"}
      full_url = "#{config[:api_url]}/api/v1/artifact_types/story/artifacts/1/refine_stream"

      response = {:ok, %{"status" => "ok", "response" => %{"message" => "Artifact stream refined successfully."}}}

      expect(Client, :api_post, fn ^full_url, ^params, _config -> response end)
      assert Artifact.stream_refine_artifact(params, config) == response
    end
  end
end
