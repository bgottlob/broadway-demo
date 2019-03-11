defmodule BroadwayDemo do
  use Broadway
  import Integer

  alias Broadway.Message

  @moduledoc """
  Documentation for BroadwayDemo.
  """

  @doc """
  Build the Broadway structure
  """
  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producers: [
        default: [
          module: {Counter, 1},
          transformer: {__MODULE__, :transform, []}
        ]
      ],
      processors: [
        default: [stages: 10]
      ],
      batchers: [
        odd_batcher: [stages: 2, batch_size: 10],
        even_batcher: [stages: 1, batch_size: 5]
      ]
    )
  end

  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def ack(:ack_id, successful, failed) do
    successful_out = Enum.map_join(successful, "\n\t", fn msg -> msg.data end)
    failed_out = Enum.map_join(failed, "\n\t", fn msg -> msg.data end)

    unless successful_out === "" do
      IO.puts "Acking successful messages:\n\t#{successful_out}"
    end

    unless failed_out === "" do
      IO.puts "Acking failed messages:\n\t#{failed_out}"
    end

    :ok
  end

  # What's impl again?
  @impl true
  def handle_message(_, %Message{data: data} = message, _) when is_odd(data) do
    message
    |> Message.update_data(&process_data/1)
    |> Message.put_batcher(:odd_batcher)
  end

  def handle_message(_, %Message{data: data} = message, _) when is_even(data) do
    message
    |> Message.update_data(&process_data/1)
    |> Message.put_batcher(:even_batcher)
  end

  def process_data(data) do
    "#{data} has been processed!"
  end

  @impl true
  def handle_batch(:odd_batcher, messages, _batch_info, _context) do
    out = Enum.map_join(messages, "\n\t", fn msg -> msg.data end)
    IO.puts "Handling odd numbers:\n\t#{out}"
    messages
  end

  def handle_batch(:even_batcher, messages, _batch_info, _context) do
    out = Enum.map_join(messages, "\n\t", fn msg -> msg.data end)
    IO.puts "Handling even numbers:\n\t#{out}"
    messages
  end
end
