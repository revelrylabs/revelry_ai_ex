defmodule ProdopsEx do
  @moduledoc """
  Documentation for `ProdopsEx`.
  """

  alias ProdopsEx.Validate

  @doc """
  Validates the provided API key and return team information.

  ## Parameters

  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example
  ```elixir
  ProdopsEx.validate(
    %ProdopsEx.Config{
      bearer_token: "your_api_key_here",
    }
  )
  ```

  ## Returns
  {:ok, %{status: "ok", response: %{"team_id" => 1, "team_name" => "ProdOps"}}}
  """
  def validate_api_key(config) do
    Validate.validate_api_key(config)
  end
end
