defmodule Clause do
  defstruct clause: []

  def to_list(clause, acc \\ [], parenthesis_number \\ 0)

  def to_list([], acc, _), do: acc

  def to_list(%Clause{clause: [[%{number: number}] | rest]}, acc, _) do
    clause_length = length(rest)
    rest = Enum.take(rest, clause_length - 1)

    to_list(rest, acc, number)
  end

  def to_list([%Clause{clause: [[%{number: number}] | rest]} | rest2], acc, _) do
    clause_length = length(rest)
    rest = Enum.take(rest, clause_length - 1)

    internal_list =
      to_list(rest, [], number)

    to_list(rest2, acc ++ [internal_list], 0)
  end

  def to_list([first | rest], acc, number) do
    to_list(rest, parse_list(first, number) ++ acc, 0)
  end

  defp parse_list(list, number) do
    new_list =
      list
      |> Enum.filter(fn x -> x != "," && x != " " end)
      |> Enum.map(&String.to_integer/1)

    if number == 1 do
      new_list
    else
      2..number
      |> Enum.reduce(new_list, fn _, acc -> [acc] end)
    end
  end
end 
