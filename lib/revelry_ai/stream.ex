defmodule RevelryAI.Stream do
  @moduledoc false
  def new(start_fun) do
    Stream.resource(
      fn ->
        case start_fun.() do
          {:ok, %HTTPoison.AsyncResponse{id: id} = res} ->
            {res, id, ""}

          {:error, %HTTPoison.Error{} = error} ->
            {:error, error}

          %HTTPoison.AsyncResponse{id: id} = res ->
            {res, id, ""}
        end
      end,
      fn
        {:error, %HTTPoison.Error{} = error} ->
          {[%{"status" => :error, "reason" => error.reason}], {:halt, error}}

        {:halt, _} = halt ->
          halt

        {res, id, buffer} ->
          receive do
            %HTTPoison.AsyncStatus{id: ^id, code: code} ->
              HTTPoison.stream_next(res)

              if code == 200 do
                {[], {res, id, buffer}}
              else
                {[%{"status" => :error, "code" => code, "choices" => []}], {:halt, res}}
              end

            %HTTPoison.AsyncHeaders{id: ^id} ->
              HTTPoison.stream_next(res)
              {[], {res, id, buffer}}

            %HTTPoison.AsyncChunk{chunk: chunk} ->
              combined_chunk = buffer <> chunk

              {events, rest_buffer} = ServerSentEvents.parse(combined_chunk)
              data = Enum.flat_map(events, &parse_events/1)

              HTTPoison.stream_next(res)
              {data, {res, id, rest_buffer}}

            %HTTPoison.AsyncEnd{} ->
              {:halt, res}
          end
      end,
      fn
        %{id: id} -> :hackney.stop_async(id)
      end
    )
  end

  # Modify this function if your ServerSentEvents.parse/1 returns differently
  defp parse_events(%{data: content}), do: [decode_json_content(content)]
  defp parse_events([%{data: content}]), do: [decode_json_content(content)]
  defp parse_events(_), do: []

  defp decode_json_content(data) do
    case Jason.decode(data) do
      {:ok, %{"content" => content}} -> content
      {:ok, map} when is_map(map) -> map
      {:error, _} -> data
    end
  end
end
