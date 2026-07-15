defmodule RevelryAI.V2.Skill do
  @moduledoc """
  Handles v2 skill execution for the RevelryAI API.

  Runs a skill asynchronously without creating an artifact. The endpoint
  returns an `api_job_id` immediately; poll for the result with
  `RevelryAI.V2.ApiJob.get/2` or `RevelryAI.V2.ApiJob.await/2`.
  """
  alias RevelryAI.Client
  alias RevelryAI.Config

  @base_path "/api/v2/skills"

  defp url(config) do
    config[:api_url] <> @base_path
  end

  @doc """
  Runs a skill asynchronously.

  ## Parameters

  - `skill_id`: the ID of the skill to run
  - `project_id`: the ID of the project to run the skill in
  - `params`: the request body:
    - `inputs` (required): a list of `%{name: name, value: value}` maps
      matching the skill's custom variables
    - `model_configuration_id` (optional): overrides the organization's
      default model configuration
  - `config` (optional): a configuration keyword list used to override default config values

  ## Example

      iex> RevelryAI.V2.Skill.run(10, 1, %{
      ...>   inputs: [
      ...>     %{name: "Context", value: "this is a test"}
      ...>   ]
      ...> })
      {:ok,
       %{
         status: "ok",
         response: %{
           "api_job_id" => 42,
           "message" => "Skill execution started."
         }
       }}

  ## Returns

  Returns `{:ok, response}` as soon as execution is enqueued (HTTP 202).
  Use the returned `api_job_id` with `RevelryAI.V2.ApiJob.get/2` or
  `RevelryAI.V2.ApiJob.await/2` to retrieve the result.
  """
  @spec run(
          integer(),
          integer(),
          %{
            required(:inputs) => [%{name: String.t(), value: String.t()}],
            optional(:model_configuration_id) => integer()
          },
          Keyword.t()
        ) :: {:ok, map()} | {:error, term()}
  def run(skill_id, project_id, %{inputs: inputs} = params, config \\ [])
      when is_integer(skill_id) and is_integer(project_id) and is_list(inputs) do
    config = Config.resolve_config(config)
    endpoint = url(config) <> "/#{skill_id}/run?project_id=#{project_id}"
    Client.api_post(endpoint, params, config)
  end
end
