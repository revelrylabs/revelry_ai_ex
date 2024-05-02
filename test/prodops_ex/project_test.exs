defmodule ProdopsEx.ProjectTest do
  use ExUnit.Case, async: true
  use Mimic

  alias ProdopsEx.Client
  alias ProdopsEx.Project

  describe "list/1" do
    test "returns a list of all projects for a given team" do
      config = [api_url: "https://api.example.com", api_key: "secret_key"]
      full_url = "#{config[:api_url]}/api/v1/projects"

      response =
        {:ok,
         %{
           "status" => "ok",
           "response" => %{
             "projects" => [
               %{"id" => 1, "name" => "ProdOps", "overview" => "This is the project overview"}
             ]
           }
         }}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert Project.list(config) == response
    end
  end
end
