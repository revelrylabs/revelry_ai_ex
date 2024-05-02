defmodule ProdopsEx.DataCenter do
  @moduledoc """
  Handles data center operations for the ProdOps API.
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/data_center"

  @doc """
  Uploads a document to the ProdOps data center.

  ## Parameters

  - `path_to_file`: the full path to the file that will be uploaded
  - `config` (optional): a configuration map used to override default config values

  ## Examples

      iex> ProdopsEx.DataCenter.upload_document("/path/to/file.txt"})
      {:ok, %{status: "ok", response: %{"id" => 4}}}
  """
  @spec upload_document(map, Keyword.t()) :: {:ok, map} | {:error, any}
  def upload_document(path_to_file, config \\ []) do
    config = Config.resolve_config(config)
    endpoint = url(config) <> "/documents/upload"
    body = {:multipart, [{:file, path_to_file, {["form-data"], [name: "\"document\"", filename: path_to_file]}, []}]}
    Client.multi_part_api_post(endpoint, body, config)
  end

  defp url(config) do
    config[:api_url] <> @base_path
  end
end
