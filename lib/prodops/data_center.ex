defmodule ProdopsEx.DataCenter do
  @moduledoc """
  Handles data center operations for the ProdOps API.
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/data_center"

  @doc """
  Uploads a document to the ProdOps data center.

  ## Examples

      iex> ProdopsEx.DataCenter.upload_document(%{file_name: "test.txt"})
      {:ok, %{status: "ok", response: %{"id" => 4}}}
  """
  @spec upload_document(map, Keyword.t()) :: {:ok, map} | {:error, any}
  def upload_document(params, config) do
    config = Config.resolve_config(config)
    %{file_name: file_name} = params
    endpoint = url(config) <> "/documents/upload"
    body = {:multipart, [{:file, file_name, {["form-data"], [name: "\"document\"", filename: file_name]}, []}]}
    Client.multi_part_api_post(endpoint, body, config)
  end

  defp url(config) do
    config[:api_url] <> @base_path
  end
end
