defmodule RevelryAI.Validate do
  @moduledoc """
  Handles validation operations for the RevelryAI API.
  """
  alias RevelryAI.Client
  alias RevelryAI.Config

  @base_path "/api/v1/validate"

  @doc """
  Validates the provided API key and returns team information.

  ## Parameters

  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> RevelryAI.Validate.validate_api_key()
      {:ok, %{status: "ok", response: %{"team_id" => 1, "team_name" => "RevelryAI"}}}
  """
  @spec validate_api_key(Keyword.t()) :: {:ok, map} | {:error, any}
  def validate_api_key(config \\ []) do
    config = Config.resolve_config(config)
    Client.api_post(url(config), %{}, config)
  end

  defp url(config) do
    config[:api_url] <> @base_path
  end
end
