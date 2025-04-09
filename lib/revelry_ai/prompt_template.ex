defmodule RevelryAI.PromptTemplate do
  @moduledoc """
  Handles prompt template operations for the RevelryAI API.

  Prompt Templates are the building blocks used for generating Artifacts.

  They are a combination of hard-coded information and variables which represent
  data that can be inserted. They are the basic building block for setting up
  repeatable workflows to generate Artifacts.

  They may look something like this:

  ```txt
  You are a helpful assistant. A user has asked a question about company
  policies, which you must answer. This is their question:

  {custom.Question}

  Use this information to answer the question:

  {query.Company Policies}
  ```

  The value `{custom.Question}` can be explicitly passed into the template
  when generating a new Artifact.

  The value `{query.Company Policies}` will automatically find relevant
  information by checking the value of an explicit input such as
  `{custom.Question}`, and can search through all Documents or a Collection of
  Documents. In this example, it might search a Collection of employee manuals,
  playbooks, etc., and will calculate the most semantically similar values
  between their sections and the user's question, which is the value input into
  `{custom.Question}`. It will then return the relevant segments and insert them
  into the prompt prior to generation. This technique is known as
  Retrieval-Augmented Generation.

  For more information, see the [RevelryAI Prompts help page](https://help.revelry.ai/docs/category/prompts).
  """
  alias RevelryAI.Client
  alias RevelryAI.Config

  @base_path "/api/v1/artifact_types"

  @doc """
  Retrieves prompt templates for a given artifact type.

  ## Parameters

  - `artifact_slug`: the type of prompt templates to return from the request
  - `config` (optional): a configuration map used to override default config values

  ## Example
      iex> RevelryAI.PromptTemplate.list("questions")
  	{:ok,
  	 %{
  		 status: "ok",
  		 response: %{
  			 "prompt_templates" => [
  				 %{
  					 "content" => "Answer this: {custom.Question} Use these docs: {query.Documents}",
  					 "custom_variables" => [
  						 %{
  							 "question" => "Question",
  							 "id" => "fc4cbbe7-8f90-4c39-a8e6-582d37884f14",
  							 "name" => "Question"
  						 }
  					 ],
  					 "description" => "Answers a question using document queries",
  					 "document_queries" => [
  						 %{
  							 "collection_id" => nil,
  							 "collection_ids" => ~c"s",
  							 "count" => 3,
  							 "id" => "6c69b859-8c40-41c9-b8f9-8bb1bdf369a1",
  							 "min_score" => 0.75,
  							 "name" => "Documents",
  							 "query" => "{custom.Question}",
  							 "type" => nil
  						 }
  					 ],
  					 "id" => 1,
  					 "name" => "Question Answering"
  				 }
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
