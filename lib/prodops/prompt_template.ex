defmodule ProdopsEx.PromptTemplate do
  @moduledoc """
  Handles prompt template operations for the ProdOps API
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/artifact_types"

  @doc """
  Retrieves prompt templates for a given artifact type.

  ## Parameters

  - `artifact_slug`: the type of prompt templates to return from the request
  - `config` (optional): a configuration map used to override default config values

  ## Example

      iex> ProdopsEx.PromptTemplate.list("story")
      {:ok,
        %{
          status: "ok",
          response: %{
            "prompt_templates" => [
              {
                "id": 3,
                "name": "Example Prompt",
                "content": "This is an example prompt template body",
                "description": "This is an example prompt template",
                "custom_variables": [
                    {
                        "id": "df57af61-7741-4152-b5eb-0484b281eaaa",
                        "name": "Example Input",
                        "description": null
                    }
                ],
                "document_queries": [
                    {
                        "id": "dcbbc393-9f00-4020-a150-ac5fa5f66095",
                        "name": "Example Document Query",
                        "query": "{custom.Example Input}",
                        "count": 1,
                        "type": "code",
                        "min_score": 0.75,
                        "collection_id": null,
                        "collection_ids": []
                    }
                ]
            },
              ...
            ]
          }
        }}

  ## Returns
  The function returns a list of prompt templates for the specified artifact type.
  """
  @spec list(String.t(), Keyword.t()) :: {:ok, list} | {:error, any}
  def list(artifact_slug, config \\ []) when is_binary(artifact_slug) do
    config = Config.resolve_config(config)
    endpoint = url(config) <> "/#{artifact_slug}/prompt_templates"
    Client.api_get(endpoint, config)
  end

  defp url(config) do
    config[:api_url] <> @base_path
  end
end
