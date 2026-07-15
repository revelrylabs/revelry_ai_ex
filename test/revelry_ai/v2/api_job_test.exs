defmodule RevelryAI.V2.ApiJobTest do
  use ExUnit.Case, async: true
  use Mimic

  alias RevelryAI.Client
  alias RevelryAI.V2.ApiJob

  setup do
    %{
      config: [
        http_options: [recv_timeout: 60_000],
        api_url: "https://api.example.com",
        api_key: "secret_key"
      ],
      api_job_id: 42
    }
  end

  defp job_response(status, extra \\ %{}) do
    {:ok, %{status: "ok", response: Map.merge(%{"id" => 42, "type" => "skill_run", "status" => status}, extra)}}
  end

  describe "get/2" do
    test "retrieves an API job by its ID", %{config: config, api_job_id: api_job_id} do
      full_url = "#{config[:api_url]}/api/v2/api_jobs/#{api_job_id}"

      response = job_response("completed", %{"content" => "The generated output."})

      expect(Client, :api_get, fn ^full_url, ^config -> response end)
      assert ApiJob.get(api_job_id, config) == response
    end
  end

  describe "await/2" do
    test "returns immediately when the job is already completed", %{config: config, api_job_id: api_job_id} do
      response = job_response("completed", %{"content" => "The generated output."})

      expect(Client, :api_get, fn _url, _config -> response end)
      assert ApiJob.await(api_job_id, config) == response
    end

    test "polls until the job reaches a terminal status", %{config: config, api_job_id: api_job_id} do
      completed = job_response("completed", %{"content" => "The generated output."})

      Client
      |> expect(:api_get, fn _url, _config -> job_response("pending") end)
      |> expect(:api_get, fn _url, _config -> job_response("running") end)
      |> expect(:api_get, fn _url, _config -> completed end)

      assert ApiJob.await(api_job_id, [interval: 1] ++ config) == completed
    end

    test "returns a failed job as a successful poll", %{config: config, api_job_id: api_job_id} do
      failed = job_response("failed", %{"error_message" => "Something went wrong."})

      expect(Client, :api_get, fn _url, _config -> failed end)
      assert ApiJob.await(api_job_id, config) == failed
    end

    test "returns {:error, :timeout} when the deadline elapses", %{config: config, api_job_id: api_job_id} do
      stub(Client, :api_get, fn _url, _config -> job_response("pending") end)

      assert ApiJob.await(api_job_id, [interval: 1, timeout: 5] ++ config) == {:error, :timeout}
    end

    test "propagates request errors without further polling", %{config: config, api_job_id: api_job_id} do
      error = {:error, %{"status" => "error", "response" => %{"code" => 404, "error" => "Not Found"}}}

      expect(Client, :api_get, fn _url, _config -> error end)
      assert ApiJob.await(api_job_id, config) == error
    end
  end
end
