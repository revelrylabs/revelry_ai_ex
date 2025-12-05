defmodule RevelryAI.ModelConfiguration do
  @moduledoc """
  Handles model configuration operations for the RevelryAI API.

  Model configurations define which LLM models are available for artifact generation.
  Each configuration includes details like the model name, provider, token limits,
  and whether features like extended thinking are enabled.
  """
  alias RevelryAI.Client
  alias RevelryAI.Config

  @base_path "/api/v1/model_configurations"

  defp url(config) do
    config[:api_url] <> @base_path
  end

  @doc """
  Returns a list of all enabled model configurations for your team.

  ## Parameters

  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> RevelryAI.ModelConfiguration.list()
      {:ok,
        %{
          status: "ok",
          response: %{
            "model_configurations" => [
              %{
                "id" => 1,
                "name" => "gpt-4o",
                "provider" => "open_ai",
                "friendly_name" => "GPT-4o",
                "enabled" => true,
                "max_completion_tokens" => 4096,
                "max_context_window" => 128000,
                "tools_supported" => true
              }
            ]
          }
        }
      }
  """
  @spec list(Keyword.t()) :: {:ok, map} | {:error, any}
  def list(config \\ []) do
    config = Config.resolve_config(config)
    Client.api_get(url(config), config)
  end

  @doc """
  Retrieves a single model configuration by its ID.

  ## Parameters

  - `id`: the ID of the model configuration
  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> RevelryAI.ModelConfiguration.get(1)
      {:ok,
        %{
          status: "ok",
          response: %{
            "model_configuration" => %{
              "id" => 1,
              "name" => "gpt-4o",
              "provider" => "open_ai",
              "friendly_name" => "GPT-4o",
              "enabled" => true,
              "max_completion_tokens" => 4096,
              "max_context_window" => 128000,
              "tools_supported" => true,
              "notes" => nil,
              "document_injection_cutoff" => nil,
              "api_version" => nil,
              "extended_thinking_enabled" => false,
              "extended_thinking_budget_tokens" => nil
            }
          }
        }
      }
  """
  @spec get(integer(), Keyword.t()) :: {:ok, map} | {:error, any}
  def get(id, config \\ []) when is_integer(id) do
    config = Config.resolve_config(config)
    endpoint = url(config) <> "/#{id}"
    Client.api_get(endpoint, config)
  end
end
