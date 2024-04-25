defmodule ProdopsEx.PromptTemplate do
  @moduledoc """
  Handles prompt template operations for the ProdOps API
  """
  alias ProdopsEx.Client
  alias ProdopsEx.Config

  @base_path "/api/v1/artifact_types/"

  @doc """
  Retrieves prompt templates for a given artifact type.

  ## Parameters

  - `params`: The parameters for the prompt template request.
  - `config`: The configuration map containing the API key and endpoint URL.

  ## Example

      iex> ProdopsEx.get_prompt_templates_for_artifact_type(%{artifact_type_slug: "story"}, %ProdopsEx.Config{bearer_token: "your_api_key_here"})
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
  The function should return a list of prompt templates for the specified artifact type.
  """
  @spec get_prompt_templates_for_artifact_type(map, %Config{}) :: {:ok, list} | {:error, any}
  def get_prompt_templates_for_artifact_type(params, %Config{} = config) do
    endpoint = url(params, config)
    Client.api_get(endpoint, [], config)
  end

  defp url(%{artifact_type_slug: artifact_type_slug}, %Config{} = config) do
    config.api_url <> @base_path <> "/#{artifact_type_slug}/prompt_templates"
  end
end
