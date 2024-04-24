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

  def api_get(path, params \\ [], config) do
    path
    |> get(request_headers(config), request_options(config, params))
    |> handle_response()
  end

  def api_post(path, params \\ [], config) do
    body =
      params
      |> Map.new()
      |> Jason.encode!()

    path
    |> post(body, request_headers(config), request_options(config, params))
    |> handle_response()
  end

  def api_delete(path, params \\ [], config) do
    path
    |> delete(request_headers(config), request_options(config, params))
    |> handle_response()
  end

  defp request_headers(config) do
    [
      {"Authorization", "Bearer #{config.bearer_token}"},
      {"Content-type", "application/json"}
    ]
  end

  defp request_options(config, params) do
    base_options = config.http_options

    case params do
      [] -> base_options
      _ -> Keyword.put_new(base_options, :params, params)
    end
  end
end
