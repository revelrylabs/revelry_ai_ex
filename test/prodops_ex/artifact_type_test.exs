defmodule ProdopsEx.ArtifactTypeTest do
  use ExUnit.Case, async: true
  use Mimic

  alias ProdopsEx.ArtifactType
  alias ProdopsEx.Client

  describe "list/1" do
    test "returns a list of all artifact types for a given team" do
      api_url = "https://api.example.com"
      api_key = "secret_key"
      full_url = "#{api_url}/api/v1/artifact_types"

      response =
        {:ok,
         %{
           status: "ok",
           response: %{
             "artifact_types" => [
               %{"slug" => "story", "name" => "Story", "description" => "This is a story"}
             ]
           }
         }}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert ArtifactType.list(api_url: api_url, api_key: api_key) == response
    end
  end
end
