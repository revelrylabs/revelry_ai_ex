defmodule ProdopsEx.Client do
  @moduledoc """
  Handles HTTP client operations for interacting with the ProdOps API.
  """
  use HTTPoison.Base

  alias ProdopsEx.Stream

  def process_response_body(body) do
    {status, res} = Jason.decode(body)

    case status do
      :ok ->
        {:ok, res}

      :error ->
        body
    end
  rescue
    _ ->
      body
  end

  def handle_response(httpoison_response) do
    case httpoison_response do
      {:ok, %HTTPoison.Response{status_code: 200, body: {:ok, body}}} ->
        res = Map.new(body, fn {k, v} -> {String.to_atom(k), v} end)

        {:ok, res}

      {:ok, %HTTPoison.Response{body: {:ok, body}}} ->
        {:error, body}

      # HTML error responses
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, %{status_code: status_code, body: body}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def api_get(url, config) do
    url
    |> get(request_headers(config), config[:http_options])
    |> handle_response()
  end

  def api_post(url, body_params \\ %{}, config) do
    body = Jason.encode!(body_params)

    if Map.get(body_params, :stream, false) do
      Stream.new(fn ->
        post(url, body, request_headers(config), stream_request_options(config))
      end)
    else
      url
      |> post(body, request_headers(config), config[:http_options])
      |> handle_response()
    end
  end

  def multi_part_api_post(path, body, config) do
    path
    |> post(body, multi_part_request_headers(config), config[:http_options])
    |> handle_response()
  end

  def api_delete(path, config) do
    path
    |> delete(request_headers(config), config[:http_options])
    |> handle_response()
  end

  defp request_headers(config) do
    [
      {"Authorization", "Bearer #{config[:api_key]}"},
      {"Content-Type", "application/json"}
    ]
  end

  defp stream_request_options(config) do
    # async: :once seems to be required to work properly with
    # HTTPoison.stream_next
    http_options = config[:http_options] ++ [async: :once]

    case http_options[:stream_to] do
      nil ->
        new_options = http_options ++ [stream_to: self()]
        new_options

      _ ->
        http_options
    end
  end

  defp multi_part_request_headers(config) do
    [
      {"Authorization", "Bearer #{config[:api_key]}"},
      {"Content-Type", "multipart/form-data"}
    ]
  end
end
