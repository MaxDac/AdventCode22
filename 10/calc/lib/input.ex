defmodule Input do
  @moduledoc false

  alias Operations

  @spec get_input() :: list({Operations.operations(), integer()})
  def get_input(input \\ "test_input") do
    File.read!("#{File.cwd!()}/lib/#{input}")
    |> split_lines()
    |> Enum.map(&parse_line/1)
  end
  
  defp split_lines(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&is_not_null_nor_empty/1)
  end

  defp is_null_or_empty(nil), do: true
  defp is_null_or_empty(""), do: true
  defp is_null_or_empty(_), do: false

  defp is_not_null_nor_empty(a), do: not is_null_or_empty(a)

  defp parse_line("addx " <> <<number::binary>>), do: {:addx, String.to_integer(number)}
  defp parse_line("noop"), do: {:noop, 0}
end
