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

  @doc """
  Create a new artifact type called "Implementation Plan".

  Create a new prompt template called "Implementation Plan".

  Input the following into the prompt:

  ```
  You are providing detailed implementation steps based on the input of the user and documents stored in our vector database.
  In each section, you will find text that is submitted by the user that represents their own high-level instructions for performing the implementation.
  For example, the first section, called "Data Transformations" might contain high-level instructions for how you are to update the database, migrations, etc. of the codebase.
  You will also find documents stored in our vector database that will be similarity-searched examples of related code based on the user input.
  Use these snippets of code to aid you in your implementation details, modifying/replacing them or writing new snippets of code such that the requirements that the user lays out at the beginning of each section are satisfied.
  Each of the sections, which will be separated by long line breaks (---), will have both user instructions and associated code that we gather via similarity search from the vector database.
  Use this data to give a detailed implementation plan with code examples. You may modify, replace, or create code as you see fit.
  Do not be succinct in your responses, be as detailed as you possibly can. If you get hung up or stop generating, the user will prompt you with the exact phrase "Please continue".
  At that point, continue generating from where you previous left off.

  ---
  Section 1: Data Transformations

  User Input:
  [DATA TRANSFORMATIONS INPUT]

  Code examples:
  [DATA TRANSFORMATIONS QUERY]

  ---

  Section 2: Backend

  User Input:
  [BACKEND INPUT]

  Code Examples:
  [BACKEND QUERY]

  ---

  Section 3: UI

  User Input:
  [UI INPUT]

  Code Examples:
  [UI QUERY]

  ---

  Section 4: Tests

  User Input:
  [TESTS INPUT]

  Code Examples:
  [TESTS QUERY]
  ```

  For this query to work, you must create the 8 data elements that are referenced in the prompt between square brackets in the "Data Elements" section of the ProdOps UI:

  For example, for Data Transformations User Input:
    - Click New Data Element in the Data Elements sidebar
    - Select a Data Element Type of User Input
    - Name your user input "Data Transformations" and give it an optional description, e.g.: "Migrations, updates to the database, etc."
    - Click Save Data Element
    - Highlight [DATA TRANSFORMATIONS INPUT] in your prompt builder text box
    - Click the + button next to your newly created User Input in the Data Elements sidebar
    - The [DATA TRANSFORMATIONS INPUT] text should be changed to {custom.Data Transformations} in the prompt builder.

  And for the Data Transformations Document Query:
    - Click New Data Element in the Data Elements sidebar
    - Select a Data Element type of Document Query
    - Name your document query "Data Transformations" and select "Data Transformations" as the Query Input
    - Using the Document Type dropdown, select what kinds of documents you want to be included in the prompt, e.g.: "Code"
    - Using the Advanced Options section, configure how many results you want included for the query, e.g.: 10 and the desired accuracy, e.g.: "Normal"
    - Click Save Data Element
    - Highlight [DATA TRANSFORMATIONS QUERY] in your prompt builder text box
    - Click the + button next to your newly created Document Query in the Data Elements sidebar
    - The [DATA TRANSFORMATIONS QUERY] text should be changed to {query.Data Transformations} in the prompt builder.

  You must repeat this process for as many sections as you have in your prompt, so that each section has a User Input and a Document Query.

  Click Save Prompt.

  Once all of the sections have been created, you can generate an implementation plan as follows, replacing the ellipses with your own information relating to what changes that need to be implemented, with as much specificity as you want (using data transformations as an example below):

  iex> user_input = %{data_transformations: "Write migration for adding a generation_limit field to teams table (integer). Default to 10, nullable (null = unlimited).", backend: "", ui: "", tests: ""}
  iex> project_id = 123
  iex> prompt_template_id = 456
  iex> ProdopsEx.Ext.Revelry.implementation_plan(user_input, prompt_template_id, project_id)
  """
  def implementation_plan(user_input, prompt_template_id, project_id) do
    ProdopsEx.Artifact.create(%{
      prompt_template_id: prompt_template_id,
      artifact_slug: "implementation_plan",
      project_id: project_id,
      inputs: [
        %{name: "Data Transformations", value: user_input.data_transformations},
        %{name: "Backend", value: user_input.backend},
        %{name: "UI", value: user_input.ui},
        %{name: "Tests", value: user_input.tests}
      ]
    })
  end
end
