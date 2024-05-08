defmodule ProdopsEx.Ext.Revelry do
  @moduledoc """
  Custom functions built by Revelry
  """

  def retrieval_augmented_generate(query, collection_id, prompt_template_id, artifact_slug, project_id) do
    ProdopsEx.Artifact.create(%{
      prompt_template_id: prompt_template_id,
      artifact_slug: artifact_slug,
      project_id: project_id
    })
  end

  @doc """
  Go to Data Center, Collections, Create a Collection. Name it Documentation.

  Upload documents or add external data sources as you wish.

  Create a New Artifact Type called "Docs Chatbot". Create a new Prompt Template,
  and give it the title Chat Input.

  Input the following into the prompt:

  Replace the values in brackets below with your own information. For the [DOCUMENT QUERY], click on "New Data Element", then choose "Document Query", and name it Documentation. Under Collections, select "Documentation". Under Query Input, choose "Create a new User Input".

  Expand the Advanced Options, and set "Number of Results" to 10.

  In the Custom User Input, name it "User Input", and give it the description "Text received from the user".

  Click Save Data Element.

  Now, delete where it says [DOCUMENT QUERY], and click on "Documentation" from the sidebar on the right. You should see it place the value `{query.Documentation}` into the Prompt Builder.

  Finally, near the bottom of the page, delete [USER INPUT]. Click on "User Input" from the sidebar, and you should see the value `{custom.User Input}`.

  Click Save Prompt.

  Now click on the newly created Prompt Template. The last number in the URL is the ID: you will use that as an input to this function.

  Now, start a conversation as follows:

  iex> ProdopsEx.Ext.Revelry.docs_chatbot("How can I edit an artifact?", 123, 123) 

  """
  def docs_chatbot(user_input, prompt_template_id, project_id) do
    ProdopsEx.Artifact.create(%{
      prompt_template_id: prompt_template_id,
      artifact_slug: "docs_chatbot",
      project_id: project_id,
      inputs: [%{name: "User Input", value: user_input}]
    })
  end

  def docs_chatbot(user_input, artifact_id) do
    ProdopsEx.Artifact.refine_artifact(%{
      artifact_id: artifact_id,
      artifact_slug: "docs_chatbot",
      refine_prompt: user_input
    })
  end
end
