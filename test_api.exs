# Simple script to test the ProdopsEx API
# Run with: mix run test_api.exs

defmodule ProdopsApiTest do
  def run do
    config = [
      api_key: System.get_env("PRODOPS_API_KEY"),
      api_url: System.get_env("PRODOPS_API_URL", "https://app.prodops.ai")
    ]

    stream_test(config)
  end

  def stream_test(config) do
    # Using hardcoded values
    artifact_slug = "test_prompt"
    prompt_template_id = 1
    project_id = 1

    # Create a streaming artifact
    params = %{
      prompt_template_id: prompt_template_id,
      project_id: project_id,
      artifact_slug: artifact_slug
    }

    # Process the stream and collect all chunks
    stream = ProdopsEx.Artifact.stream_create_artifact(params, config)

    try do
      # Collect all chunks into a list
      chunks =
        stream
        |> Elixir.Stream.map(fn chunk -> chunk end)
        |> Elixir.Enum.to_list()

      # Show number of chunks received
      IO.puts("Received #{length(chunks)} chunks")

      # Display each chunk separately with its index
      chunks
      |> Enum.with_index()
      |> Enum.each(fn {chunk, i} ->
        IO.puts("\n--- Chunk #{i + 1} ---")
        IO.inspect(chunk)
      end)

      # Combine all chunks to see if we can reconstruct the complete content
      combined = Enum.join(chunks, "")
      IO.puts("\n--- Combined Result ---")
      IO.puts(combined)
    rescue
      e ->
        IO.puts("Error processing stream:")
        IO.inspect(e)
    end
  end
end

# Run the tests
ProdopsApiTest.run()
