defmodule Calc do
  def compute(file_name \\ "input") do
    File.read!(file_name)
    |> cleanup_input()
    |> Enum.map(&divide_tasks/1)
    # |> Enum.filter(&completely_overlaps?/1)
    # |> Enum.filter(&overlaps?/1)
    |> Enum.filter(fn x -> completely_overlaps?(x) || overlaps?(x) end)
    |> Enum.count()
  end

  defp cleanup_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(fn 
      "" -> false
      nil -> false
      _ -> true
    end)
  end

  defp divide_tasks(task) do
    task
    |> String.split(",")
    |> Enum.map(&identify_range/1)
  end
  
  defp identify_range(range) do
    [a, b] = 
      String.split(range, "-")
      |> Enum.map(&parse_number/1)

    {a, b}
  end

  defp parse_number(number) do
    {n, _} = Integer.parse(number)
    n
  end

  defp completely_overlaps?(ranges)
  defp completely_overlaps?([{a1, b1}, {a2, b2}]) when a1 <= a2 and b1 >= b2, do: true
  defp completely_overlaps?([{a1, b1}, {a2, b2}]) when a1 >= a2 and b1 <= b2, do: true
  defp completely_overlaps?(_), do: false

  defp overlaps?(ranges)
  defp overlaps?([{a1, b1}, {a2, b2}]) when a1 <= a2 and b1 >= a2, do: true
  defp overlaps?([{a1, b1}, {a2, b2}]) when a1 <= b2 and b1 >= b2, do: true
  defp overlaps?(_), do: false
end
