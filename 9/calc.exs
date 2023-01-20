defmodule Calc do  
  @moduledoc false

  Code.require_file("../shared/input_helpers.exs")
  Code.require_file("./input.exs")
  Code.require_file("./rope.exs")
  Code.require_file("./state_collector.exs")

  def compute(input \\ "test_input") do
    server = StateCollector.start_link()
    rope_server = Rope.start_link()

    final_position = 
      input
      |> Input.parse_input()
      |> transform_input()
      |> apply_move(server, rope_server)

    server
    |> StateCollector.get()
    |> MapSet.new()
    |> Enum.count()
  end

  defp transform_input(input) do
    Enum.reduce(input, [], fn 
      {direction, quantity}, acc ->
        1..quantity
        |> Enum.reduce(acc, fn _, a -> [direction | a] end)
    end)
    |> Enum.reverse()
  end

  defp apply_move(directions, server, rope_server, acc \\ nil)

  defp apply_move([], _, _, acc), do: acc

  defp apply_move([direction | rest], server, rope_server, _) do
    new_tail_position = 
      Rope.move_rope(rope_server, direction)

    StateCollector.put(server, new_tail_position)
    apply_move(rest, server, rope_server, new_tail_position)
  end

end

