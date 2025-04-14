defmodule RevelryAI.Stream do
  @moduledoc false

  @doc """
  Creates a readable stream of information that another process can consume.

  This is used for endpoints that support returning text as it is generated,
  rather than waiting for the entire generation output to be ready.
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
              {events, _} = ServerSentEvents.parse(chunk)

              data =
                Enum.flat_map(events, &parse_events/1)

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

  defp parse_events(%{data: content}) do
    decoded = decode_json_content(content)
    [decoded]
  end

  defp parse_events([%{data: content}]) do
    decoded = decode_json_content(content)
    [decoded]
  end

  defp parse_events(_) do
    []
  end

  defp decode_json_content(data) do
    case Jason.decode(data) do
      {:ok, %{"content" => content}} ->
        content

      {:ok, map} when is_map(map) ->
        # For response_body events or other structured data
        map

      {:error, _error} ->
        # Not JSON or doesn't have content field, return as is
        data
    end
  end
end
