defmodule Input do
  @moduledoc false

  Code.require_file("../shared/input_helpers.exs")

  def parse_input(input \\ "test_input") do
    File.read!(input)
    |> InputHelpers.get_input_rows()
    |> Enum.map(&parse_input_row/1)
  end

  defp parse_input_row(<<direction::utf8>> <> " " <> <<quantity::binary>>) do
    {
      parse_direction(<<direction>>), 
      InputHelpers.parse_int(quantity)
    }
  end

  defp parse_direction("U"), do: :up
  defp parse_direction("D"), do: :down
  defp parse_direction("L"), do: :left
  defp parse_direction("R"), do: :right
end
