defmodule RevelryAI.DataCenterTest do
  use ExUnit.Case, async: true
  use Mimic

  alias RevelryAI.Client
  alias RevelryAI.DataCenter

  describe "upload_document/2" do
    test "uploads a document and returns the server response" do
      config = [api_url: "https://api.example.com", api_key: "secret_key"]
      path_to_file = "/path/to/file.txt"
      full_url = "#{config[:api_url]}/api/v1/data_center/documents/upload"

      response = {:ok, %{"status" => "ok", "response" => %{"id" => 4}}}

      expect(Client, :multi_part_api_post, fn ^full_url, _body, _config -> response end)
      assert DataCenter.upload_document(path_to_file, config) == response
    end
  end
end
