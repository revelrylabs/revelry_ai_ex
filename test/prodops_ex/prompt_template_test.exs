defmodule ProdopsEx.PromptTemplateTest do
  use ExUnit.Case, async: true
  use Mimic

  alias ProdopsEx.Client
  alias ProdopsEx.PromptTemplate

  describe "list/2" do
    test "retrieves prompt templates for a given artifact type" do
      artifact_slug = "story"
      config = [api_url: "https://api.example.com", api_key: "secret_key"]
      full_url = "#{config[:api_url]}/api/v1/artifact_types/#{artifact_slug}/prompt_templates"

      response =
        {:ok,
         %{
           "status" => "ok",
           "response" => %{
             "prompt_templates" => [
               %{
                 "id" => 3,
                 "name" => "Example Prompt",
                 "content" => "This is an example prompt template body",
                 "description" => "This is an example prompt template",
                 "custom_variables" => [
                   %{
                     "id" => "df57af61-7741-4152-b5eb-0484b281eaaa",
                     "name" => "Example Input",
                     "description" => nil
                   }
                 ],
                 "document_queries" => [
                   %{
                     "id" => "dcbbc393-9f00-4020-a150-ac5fa5f66095",
                     "name" => "Example Document Query",
                     "query" => "{custom.Example Input}",
                     "count" => 1,
                     "type" => "code",
                     "min_score" => 0.75,
                     "collection_id" => nil,
                     "collection_ids" => []
                   }
                 ]
               }
             ]
           }
         }}

      expect(Client, :api_get, fn ^full_url, _config -> response end)
      assert PromptTemplate.list(artifact_slug, config) == response
    end
  end
end
