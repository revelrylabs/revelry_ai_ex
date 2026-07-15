defmodule RevelryAI.V2.ApiJob do
  @moduledoc """
  Handles polling of asynchronous API jobs for the RevelryAI v2 API.

  Jobs are created by async v2 endpoints such as `RevelryAI.V2.Skill.run/4`
  and progress from `"pending"` to `"running"` to either `"completed"` or
  `"failed"`. Once completed, the job's `"content"` holds the AI output; on
  failure, `"error_message"` describes what went wrong.
  """
  alias RevelryAI.Client
  alias RevelryAI.Config

  @base_path "/api/v2/api_jobs"
  @terminal_statuses ["completed", "failed"]
  @default_interval 2_000
  @default_timeout 120_000

  defp url(config) do
    config[:api_url] <> @base_path
  end

  @doc """
  Retrieves an API job by its ID.

  ## Parameters

  - `api_job_id`: the ID of the API job
  - `config` (optional): a configuration keyword list used to override default config values

  ## Example

      iex> RevelryAI.V2.ApiJob.get(42)
      {:ok,
       %{
         status: "ok",
         response: %{
           "id" => 42,
           "type" => "skill_run",
           "status" => "completed",
           "project_id" => 1,
           "chat_id" => nil,
           "metadata" => %{"skill_id" => 10},
           "content" => "The generated output.",
           "error_message" => nil,
           "inserted_at" => "2026-07-15T00:00:00Z",
           "updated_at" => "2026-07-15T00:00:30Z"
         }
       }}
  """
  @spec get(integer(), Keyword.t()) :: {:ok, map()} | {:error, term()}
  def get(api_job_id, config \\ []) when is_integer(api_job_id) do
    config = Config.resolve_config(config)
    endpoint = url(config) <> "/#{api_job_id}"
    Client.api_get(endpoint, config)
  end

  @doc """
  Polls an API job until it reaches a terminal status (`"completed"` or
  `"failed"`) or the timeout elapses.

  A failed job is still a successful poll: it is returned as `{:ok, response}`
  and callers should branch on the job's `"status"` and `"error_message"`.

  ## Parameters

  - `api_job_id`: the ID of the API job
  - `opts` (optional): polling options plus any configuration overrides:
    - `interval`: milliseconds between polls (default `#{@default_interval}`)
    - `timeout`: overall deadline in milliseconds (default `#{@default_timeout}`)
    - any other keys are treated as configuration overrides (e.g. `api_key`)

  ## Example

      iex> RevelryAI.V2.ApiJob.await(42, timeout: 300_000)
      {:ok, %{status: "ok", response: %{"id" => 42, "status" => "completed", "content" => "..."}}}

  ## Returns

  `{:ok, response}` once the job is completed or failed, `{:error, :timeout}`
  if the deadline elapses first, or `{:error, reason}` on a request error.
  """
  @spec await(integer(), Keyword.t()) :: {:ok, map()} | {:error, term()}
  def await(api_job_id, opts \\ []) when is_integer(api_job_id) do
    {poll_opts, config} = Keyword.split(opts, [:interval, :timeout])
    interval = Keyword.get(poll_opts, :interval, @default_interval)
    timeout = Keyword.get(poll_opts, :timeout, @default_timeout)
    deadline = System.monotonic_time(:millisecond) + timeout
    do_await(api_job_id, config, interval, deadline)
  end

  defp do_await(api_job_id, config, interval, deadline) do
    case get(api_job_id, config) do
      {:ok, %{response: %{"status" => status}}} = result when status in @terminal_statuses ->
        result

      {:ok, _job_in_progress} ->
        if System.monotonic_time(:millisecond) + interval > deadline do
          {:error, :timeout}
        else
          Process.sleep(interval)
          do_await(api_job_id, config, interval, deadline)
        end

      {:error, _reason} = error ->
        error
    end
  end
end
