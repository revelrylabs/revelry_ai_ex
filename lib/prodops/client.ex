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

      # html error responses
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, %{status_code: status_code, body: body}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def request_headers(config) do
    [
      bearer(config),
      {"Content-type", "application/json"}
    ]
  end

  def bearer(config), do: {"Authorization", "Bearer #{config.bearer_token}"}

  def request_options(config), do: config.http_options

  def api_post(path, params \\ [], config) do
    body =
      params
      |> Map.new()
      |> Jason.encode!()

    path
    |> post(body, request_headers(config), request_options(config))
    |> handle_response()
  end
end
