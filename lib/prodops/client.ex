defmodule ProdopsEx.Client do
  @moduledoc """
  Handles HTTP client operations for interacting with the ProdOps API.
  """
  use HTTPoison.Base

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
    |> get(request_headers(config), config.http_options)
    |> handle_response()
  end

  def api_post(url, body_params \\ [], config) do
    body =
      body_params
      |> Map.new()
      |> Jason.encode!()

    url
    |> post(body, request_headers(config), config.http_options)
    |> handle_response()
  end

  def multi_part_api_post(path, body, config) do
    path
    |> post(body, multi_part_request_headers(config), config.http_options)
    |> handle_response()
  end

  def api_delete(path, config) do
    path
    |> delete(request_headers(config), config.http_options)
    |> handle_response()
  end

  defp request_headers(config) do
    [
      {"Authorization", "Bearer #{config.bearer_token}"},
      {"Content-Type", "application/json"}
    ]
  end

  defp multi_part_request_headers(config) do
    [
      {"Authorization", "Bearer #{config.bearer_token}"},
      {"Content-Type", "multipart/form-data"}
    ]
  end

end
