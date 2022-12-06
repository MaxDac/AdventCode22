defmodule Calc do
  def compute(file_name \\ "input") do
    content = 
      File.read!(file_name)
      |> clean_file_content()

    crates =
      content
      |> Enum.take(8)
      |> get_crates()

    operations = 
      content
      |> Enum.drop(9)
      |> get_operations()

    apply_operations(crates, operations)
    |> Enum.map(fn {_, [first | _]} -> first end)
  end

  defp clean_file_content(file_content) do
    file_content
    |> String.split("\n")
    |> Enum.filter(&filter_empty/1)
  end

  defp filter_empty(""), do: false
  defp filter_empty(nil), do: false
  defp filter_empty(_), do: true

  defp get_crates(list) do
    input = 
      list
      |> Enum.map(&String.split(&1, " "))
      # |> Enum.map(&Enum.map(&1, fn "[" <> <<x::utf8>> <> "]" -> x end))
      |> Enum.reverse()
    
    max_crate =
      input
      |> Enum.at(0)
      |> Enum.count()

    input  
    |> Enum.flat_map(& &1)
    |> transpose(max_crate)
    |> remove_empty_crates()
  end

  defp transpose(list, i \\ 0, max, acc \\ %{})
  defp transpose([], _, _, acc), do: acc
  defp transpose([next | rest], i, max, acc) do
    next_i = if i == max - 1 do 0 else i + 1 end
    transpose(rest, next_i, max, Map.update(acc, i + 1, [next], &([next | &1])))
  end

  defp remove_empty_crates(map, i \\ 1)
  defp remove_empty_crates(map, 10), do: map
  defp remove_empty_crates(map, i) do
    new_map = Map.update!(map, i, fn x -> Enum.filter(x, &(&1 != "[\\]")) end)
    remove_empty_crates(new_map, i + 1)
  end

  defp get_operations(input) do
    input
    |> Enum.map(&String.replace(&1, "move ", ""))
    |> Enum.map(&String.replace(&1, "from ", ""))
    |> Enum.map(&String.replace(&1, "to ", ""))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn x -> Enum.map(x, &parse_number/1) end)
    |> Enum.map(fn [a, b, c] -> {a, b, c} end)
  end

  defp parse_number(string) do
    case Integer.parse(string) do
      {number, ""} -> number
      _ -> nil
    end
  end

  defp apply_operations(map, []), do: map
  defp apply_operations(map, [operation | others]) do
    apply_operations(move(map, operation), others)
  end

  defp move(map, {how_much, from, to}) do
    from_crates = map[from]
    to_crates = map[to]
    
    {from_crates, to_crates} = actionate_crane(from_crates, to_crates, how_much)

    map
    |> Map.update!(from, fn _ -> from_crates end)
    |> Map.update!(to, fn _ -> to_crates end)
  end

  defp actionate_crane(from, to, how_much, acc \\ [])
  defp actionate_crane(from, to, 0, acc), do: {from, Enum.reverse(acc) ++ to}
  defp actionate_crane([first | from], to, i, acc) do
    actionate_crane(from, to, i - 1, [first | acc])
  end
end
