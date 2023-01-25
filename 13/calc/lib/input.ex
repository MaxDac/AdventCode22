defmodule Input do
  @moduledoc false

  def parse_input(input) do
    input
    |> get_complete_file_path()
    |> File.read!()
    |> divide_lines()
  end

  defp divide_lines(input) do
    list =
      case String.split(input, "\n") do
        ["" | rest] -> rest
        rest -> rest
      end

    list_length = length(list)

    case Enum.at(list, list_length - 1) do
      "" -> Enum.take(list, list_length - 1)
      _ -> list
    end
  end

  defp get_complete_file_path(filename) do
    "#{Path.dirname(__DIR__)}/lib/#{filename}"
  end

  def is_not_null_nor_empty(nil), do: false
  def is_not_null_nor_empty(""), do: false
  def is_not_null_nor_empty(_), do: true

  def parse_line(line) do
    line
    |> get_elements()
    |> split_first_single_clause()
  end

  defp get_elements(line) do
    line
    |> String.split("")
    |> Enum.filter(&is_not_null_nor_empty/1)
  end

  defp split_first_single_clause(line) do
    line
    |> Enum.chunk_by(fn x -> x == "[" || x == "]" end)
    # |> IO.inspect()
    |> split_parenthesis()
    # |> IO.inspect()
    |> parse_parenthesis()
    # |> IO.inspect()
    |> parse_chunks()
    |> IO.inspect(label: "chunks")
    |> Clause.to_list()
  end

  defp split_parenthesis(list, acc \\ [])
  defp split_parenthesis([], acc), do: Enum.reverse(acc)
  defp split_parenthesis([["["] | rest], acc), do: split_parenthesis(rest, [["["] | acc])
  defp split_parenthesis([parenthesis = ["[" | _] | rest], acc) do
    split_parenthesis(rest, divide_list(parenthesis) ++ acc)
  end
  defp split_parenthesis([["]"] | rest], acc), do: split_parenthesis(rest, [["]"] | acc])
  defp split_parenthesis([parenthesis = ["]" | _] | rest], acc) do
    split_parenthesis(rest, divide_list(parenthesis) ++ acc)
  end
  defp split_parenthesis([element | rest], acc), do: split_parenthesis(rest, [element | acc])

  defp parse_parenthesis(list, acc \\ [])
  
  defp parse_parenthesis([], acc), do: Enum.reverse(acc)

  defp parse_parenthesis([["["] | rest], acc), do: 
    parse_parenthesis([[%Parenthesis{type: "["}] | rest], acc)
  defp parse_parenthesis([[%Parenthesis{type: "[", number: number}] | [["["] | rest]], acc), do: 
    parse_parenthesis([[%Parenthesis{type: "[", number: number + 1}] | rest], acc)

  defp parse_parenthesis([["]"] | rest], acc), do: 
    parse_parenthesis([[%Parenthesis{type: "]"}] | rest], acc)
  defp parse_parenthesis([[%Parenthesis{type: "]", number: number}] | [["]"] | rest]], acc), do: 
    parse_parenthesis([[%Parenthesis{type: "]", number: number + 1}] | rest], acc)

  defp parse_parenthesis([element | rest], acc), do:
    parse_parenthesis(rest, [element | acc])

  defp divide_list(list, acc \\ [])
  defp divide_list([], acc), do: Enum.reverse(acc)
  defp divide_list([el | rest], acc), do: divide_list(rest, [[el] | acc])

  defp parse_chunks(chunks, parenthesis \\ 0, previous \\ [], acc \\ nil)

  defp parse_chunks([], _, [previous], _), do: previous
  defp parse_chunks([], _, previous, _), do: previous

  # There was a previous clause under examination, restarting and saving the previous clause in the previous accumulator
  defp parse_chunks([par = [%Parenthesis{type: "[", number: number}] | rest], _, previous, %Clause{clause: clause}) do
    parse_chunks(rest, number, clause ++ previous, %Clause{clause: [par]})
  end

  # No clause under examination here, the examination can start without saving
  defp parse_chunks([par = [%Parenthesis{type: "[", number: number}] | rest], _, previous, _) do
    parse_chunks(rest, number, previous, %Clause{clause: [par]})
  end

  # The clause close with the same number of parenthesis as the opening clause, saving normally
  defp parse_chunks([par = [%Parenthesis{type: "]", number: number}] | rest], number, previous, %Clause{clause: clause}) do
    parse_chunks(Enum.reverse(previous) ++ [%Clause{clause: Enum.reverse([par | clause])} | rest], 0, [], nil)
  end

  # The clause close with a greater number of parenthesis as the opening clause, saving while reestablishing a new opening clause
  defp parse_chunks([[%Parenthesis{type: "]", number: number}] | rest], previous_number, previous, %Clause{clause: clause}) when number > previous_number do
    new_par = [%Parenthesis{type: "]", number: number - previous_number}]

    parse_chunks(
      Enum.reverse(previous) ++ [%Clause{clause: Enum.reverse([new_par | clause])} | rest] ++ [[%Parenthesis{type: "]", number: number - previous_number}]],
      number - previous_number,
      [], 
      nil)
  end

  # The clause close with a lesser number of parenthesis as the opening clause, saving while reestablishing a new opening clause
  defp parse_chunks([[%Parenthesis{type: "]", number: number}] | rest], previous_number, previous, %Clause{clause: clause}) do
    new_par = [%Parenthesis{type: "]", number: previous_number - number}]

    parse_chunks(
      Enum.reverse(previous) ++ [%Parenthesis{type: "[", number: previous_number - number} | [%Clause{clause: Enum.reverse([new_par | clause])} | rest]], 
      previous_number - number,
      [], 
      nil)
  end

  defp parse_chunks([element | rest], number, previous, %Clause{clause: clause}) do
    parse_chunks(rest, number, previous, %Clause{clause: [element | clause]})
  end

  defp parse_chunks([element | rest], number, previous, _) do
    parse_chunks(rest, number, [element | previous], %Clause{clause: [element]})
  end
end

