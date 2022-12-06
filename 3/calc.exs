defmodule Calc do
  @ascii_uppercase_offset 64
  @ascii_lowercase_offset 96
  @points_uppercase_offset 26
  
  def compute(file_name) do
    File.read!(file_name)
    # |> prepare_input()
    # |> find_doubles()
    # |> Enum.map(&get_letter_value/1)
    |> prepare_second_input() 
    |> divide_by_three()
    |> IO.inspect()
    |> Enum.map(&find_common_item/1)
    |> Enum.map(&get_letter_value/1)
    |> Enum.sum()
  end
  
  defp prepare_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&filter_empty/1)
    |> Enum.map(&split_letters/1)
    |> Enum.filter(&filter_empty/1)
    |> Enum.map(&split_array_in_two/1)
    |> Enum.filter(&filter_empty_lists/1)
  end

  defp prepare_second_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&filter_empty/1)
    |> Enum.map(&split_letters/1)
    |> Enum.filter(&filter_empty/1)
  end

  defp divide_by_three(list, acc \\ [])
  defp divide_by_three([], acc), do: acc
  defp divide_by_three(list, acc) do
    {group, rest} = Enum.split(list, 3)
    divide_by_three(rest, [group | acc])
  end

  defp find_common_item(list) do
    [a, b, c] = 
      list
      |> Enum.map(&MapSet.new/1)

    a
    |> MapSet.intersection(b)
    |> MapSet.intersection(c)
    |> Enum.at(0)
  end

  defp filter_empty(""), do: false
  defp filter_empty(nil), do: false
  defp filter_empty(_), do: true

  defp split_letters(string) do
    string
    |> String.split("")
    |> Enum.filter(&filter_empty/1)
  end
  
  defp split_array_in_two(array) do
    half = div(Enum.count(array), 2)
    Enum.split(array, half)
  end

  defp filter_empty_lists({[], _}), do: false
  defp filter_empty_lists({_, []}), do: false
  defp filter_empty_lists(_), do: true

  defp find_doubles(list) do
    list
    |> Enum.map(fn {first, second} -> {MapSet.new(first), second} end)
    |> Enum.map(&find_existent/1)
  end

  defp find_existent({set, list}) do
    list
    |> Enum.reduce(nil, fn 
      _, result when not is_nil(result) -> result
      item, _ -> if MapSet.member?(set, item) do item else nil end
    end)
  end

  def get_letter_value(letter) do
    <<letter_in_ascii>> = letter

    case letter_in_ascii do
      n when n < @ascii_lowercase_offset -> n - @ascii_uppercase_offset + @points_uppercase_offset
      n -> n - @ascii_lowercase_offset
    end
  end
end
