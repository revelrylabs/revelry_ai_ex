defmodule ProdopsEx.Stream do
  @moduledoc """
  Handles streaming operations for the ProdOps API.
  """

  def new(start_fun) do
    Stream.resource(
      start_fun,
      fn
        {:error, %HTTPoison.Error{} = error} ->
          {
            [
              %{
                "status" => :error,
                "reason" => error.reason
              }
            ],
            error
          }

        %HTTPoison.Error{} = error ->
          {:halt, error}

        res ->
          {res, id} =
            case res do
              {:ok, %HTTPoison.AsyncResponse{id: id} = res} ->
                {res, id}

              %HTTPoison.AsyncResponse{id: id} = res ->
                {res, id}
            end

          receive do
            %HTTPoison.AsyncStatus{id: ^id, code: code} ->
              # Having and IO.inspect here fixes a bug, need to fix more permanently
              IO.inspect(code, label: "Stream status code")
              HTTPoison.stream_next(res)

              case code do
                200 ->
                  {[], res}

                _ ->
                  {
                    [
                      %{
                        "status" => :error,
                        "code" => code,
                        "choices" => []
                      }
                    ],
                    res
                  }
              end

            %HTTPoison.AsyncHeaders{id: ^id, headers: _headers} ->
              HTTPoison.stream_next(res)
              {[], res}

            %HTTPoison.AsyncChunk{chunk: chunk} ->
              data =
                chunk
                |> String.split("\n")
                |> Enum.filter(fn line -> String.starts_with?(line, "data: ") end)
                |> Enum.map(fn line -> String.trim_leading(line, "data: ") end)

              HTTPoison.stream_next(res)
              {data, res}

            %HTTPoison.AsyncEnd{} ->
              {:halt, res}
          end
      end,
      fn %{id: id} ->
        :hackney.stop_async(id)
      end
    )
  end
end
