defmodule RevelryAI.ClientTest do
  use ExUnit.Case

  describe "handle_response/1" do
    test "it should respond with success if HTTP status code 200 and the response is a JSON" do
      res =
        RevelryAI.Client.handle_response({:ok, %HTTPoison.Response{body: {:ok, %{"key" => "value"}}, status_code: 200}})

      assert {:ok, %{key: "value"}} = res
    end

    test "it should respond with error if HTTP status code is not 200" do
      res =
        RevelryAI.Client.handle_response(
          {:ok, %HTTPoison.Response{body: {:ok, %{"error" => "Not found"}}, status_code: 404}}
        )

      assert {:error, %{"error" => "Not found"}} = res
    end

    test "it should handle non-JSON responses correctly" do
      res =
        RevelryAI.Client.handle_response({:ok, %HTTPoison.Response{body: "Service Unavailable", status_code: 503}})

      assert {:error, %{status_code: 503, body: "Service Unavailable"}} = res
    end

    test "it should handle HTTPoison errors" do
      res =
        RevelryAI.Client.handle_response({:error, %HTTPoison.Error{reason: :timeout}})

      assert {:error, :timeout} = res
    end
  end
end
