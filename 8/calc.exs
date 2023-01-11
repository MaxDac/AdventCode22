defmodule Calc do
  @moduledoc false

  Code.require_file("visibility.exs")

  alias Visibility

  def compute(filename \\ "test_input") do
    File.read!(filename)   
    |> interpret_input()
  end

  def interpret_input(content) do
    matrix = 
      content
      |> split_string("\n")
      |> Enum.map(&interpret_line/1)
      |> make_matrix()

    {height, width} = get_matrix_height(content)

    # empty_matrix = create_empty_matrix(height, width)

    # count =
    #   empty_matrix
    #   |> traverse_left_right(matrix, height, width, get_matrix_element(matrix, 1, 0))
    #   |> traverse_right_left(matrix, height, width, get_matrix_element(matrix, 1, width - 1), width - 2)
    #   |> traverse_up_down(matrix, height, width, get_matrix_element(matrix, 0, 1))
    #   |> traverse_down_up(matrix, height, width, get_matrix_element(matrix, height - 1, 1), height - 2)
    #   |> count_matrix(height, width)

    visibility_matrix = create_empty_matrix(height, width, 0)

    compute_visibility(visibility_matrix, matrix, height, width)
    |> max_of_matrix()
  end 
  
  def make_matrix(matrix) do
    matrix
    |> Enum.map(&list_to_tuple/1)
    |> list_to_tuple()
  end

  defp split_string(content, divider) do
    content
    |> String.split(divider)
    |> Enum.filter(&filter_nulls/1)
  end
  
  defp convert_to_int(list) do
    list
    |> Enum.map(fn x -> 
      case Integer.parse(x) do
        {num, _} -> num
      end
    end)
  end

  defp interpret_line(line) do
    split_string(line, "")
    |> convert_to_int()
  end

  defp filter_nulls(""), do: false
  defp filter_nulls(nil), do: false
  defp filter_nulls(_), do: true

  defp list_to_tuple(list) do
    list
    |> List.to_tuple()
  end

  def get_matrix_element(matrix, i, j) do
    matrix
    |> elem(i)
    |> elem(j)
  end
  
  def update_matrix_element(matrix, i, j, new_value) do
    line = elem(matrix, i)

    new_line = 
      line
      |> Tuple.delete_at(j)
      |> Tuple.insert_at(j, new_value)

    matrix
    |> Tuple.delete_at(i)
    |> Tuple.insert_at(i, new_line)
  end

  def get_matrix_height(content) do
    temp = 
      content
      |> split_string("\n")

    width = 
      temp
      |> Enum.at(0)
      |> String.length()

    height =
      temp
      |> Enum.count()

    {height, width}
  end

  def create_empty_matrix(level, width, item \\ false, acc \\ [])

  def create_empty_matrix(0, _, _, acc) do
    acc
    |> make_matrix()
  end

  def create_empty_matrix(level, width, item, acc) do
    line = 
      1..width
      |> Enum.map(fn _ -> item end)

    create_empty_matrix(level - 1, width, item, [line | acc])
  end

  def traverse_left_right(result, matrix, height, width, previous, level \\ 1, pivot \\ 1)
  def traverse_left_right(result, matrix, height, width, _, level, pivot) when pivot >= width - 1, do: 
    traverse_left_right(result, matrix, height, width, get_matrix_element(matrix, level + 1, 0), level + 1, 1)

  def traverse_left_right(result, _, height, _, _, level, _) when level >= height - 1, do: 
    result

  def traverse_left_right(result, matrix, height, width, previous, level, pivot) do
    element = get_matrix_element(matrix, level, pivot)
    result_element = get_matrix_element(result, level, pivot)
    new_previous = max(element, previous)

    case {element, result_element} do
      {e, false} when e > previous -> traverse_left_right(update_matrix_element(result, level, pivot, true), matrix, height, width, new_previous, level, pivot + 1)
      _ -> traverse_left_right(result, matrix, height, width, new_previous, level, pivot + 1)
    end
  end

  def traverse_right_left(result, matrix, height, width, previous, level \\ 1, pivot)
  def traverse_right_left(result, matrix, height, width, _, level, pivot) when pivot < 1, do: 
    traverse_right_left(result, matrix, height, width, get_matrix_element(matrix, level + 1, width - 1), level + 1, width - 2)

  def traverse_right_left(result, _, height, _, _, level, _) when level >= height - 1, do: 
    result

  def traverse_right_left(result, matrix, height, width, previous, level, pivot) do
    element = get_matrix_element(matrix, level, pivot)
    result_element = get_matrix_element(result, level, pivot)
    new_previous = max(element, previous)

    case {element, result_element} do
      {e, false} when e > previous -> traverse_right_left(update_matrix_element(result, level, pivot, true), matrix, height, width, new_previous, level, pivot - 1)
      _ -> traverse_right_left(result, matrix, height, width, new_previous, level, pivot - 1)
    end
  end

  def traverse_up_down(result, matrix, height, width, previous, level \\ 1, pivot \\ 1)
  def traverse_up_down(result, _, _, width, _, _, pivot) when pivot >= width - 1, do: 
    result

  def traverse_up_down(result, matrix, height, width, _, level, pivot) when level >= height - 1, do: 
    traverse_up_down(result, matrix, height, width, get_matrix_element(matrix, 0, pivot + 1), 1, pivot + 1)

  def traverse_up_down(result, matrix, height, width, previous, level, pivot) do
    element = get_matrix_element(matrix, level, pivot)
    result_element = get_matrix_element(result, level, pivot)
    new_previous = max(element, previous)

    case {element, result_element} do
      {e, false} when e > previous -> traverse_up_down(update_matrix_element(result, level, pivot, true), matrix, height, width, new_previous, level + 1, pivot)
      _ -> traverse_up_down(result, matrix, height, width, new_previous, level + 1, pivot)
    end
  end

  def traverse_down_up(result, matrix, height, width, previous, level, pivot \\ 1)
  def traverse_down_up(result, _, _, width, _, _, pivot) when pivot >= width - 1, do: 
    result

  def traverse_down_up(result, matrix, height, width, _, level, pivot) when level < 1, do: 
    traverse_down_up(result, matrix, height, width, get_matrix_element(matrix, height - 1, pivot + 1), height - 2, pivot + 1)

  def traverse_down_up(result, matrix, height, width, previous, level, pivot) do
    element = get_matrix_element(matrix, level, pivot)
    result_element = get_matrix_element(result, level, pivot)
    new_previous = max(element, previous)

    case {element, result_element} do
      {e, false} when e > previous -> traverse_down_up(update_matrix_element(result, level, pivot, true), matrix, height, width, new_previous, level - 1, pivot)
      _ -> traverse_down_up(result, matrix, height, width, new_previous, level - 1, pivot)
    end
  end

  def count_matrix(matrix, width, height, i \\ 1, j \\ 1, acc \\ 0)
  def count_matrix(_, width, height, i, _, acc) when i >= height - 1, do: 
    acc + width * 2 + (height - 2) * 2

  def count_matrix(matrix, width, height, i, j, acc) when j >= width - 1, do:
    count_matrix(matrix, width, height, i + 1, 1, acc)

  def count_matrix(matrix, width, height, i, j, acc) do
    if get_matrix_element(matrix, i, j) do
      count_matrix(matrix, width, height, i, j + 1, acc + 1)
    else
      count_matrix(matrix, width, height, i, j + 1, acc)
    end
  end

  def compute_visibility(visibility_matrix, matrix, height, width, i \\ 1, j \\ 1)
  def compute_visibility(visibility_matrix, _, height, _, i, _) when i >= height - 1, do: visibility_matrix
  def compute_visibility(visibility_matrix, matrix, height, width, i, j) when j >= width - 1, do: 
    compute_visibility(visibility_matrix, matrix, height, width, i + 1, 1)
  
  def compute_visibility(visibility_matrix, matrix, height, width, i, j) do
    value = get_matrix_point(matrix, i, j)

    top = compute_visibility_point(matrix, value, j, (i - 1)..0, :vertical)
    bottom = compute_visibility_point(matrix, value, j, (i + 1)..(height - 1), :vertical)
    left = compute_visibility_point(matrix, value, i, (j - 1)..0, :horizontal)
    right = compute_visibility_point(matrix, value, i, (j + 1)..(width - 1), :horizontal)

    visibility = top * bottom * left * right

    new_visibility_matrix = 
      update_matrix_element(visibility_matrix, i, j, visibility)

    compute_visibility(new_visibility_matrix, matrix, height, width, i, j + 1)
  end

  defp compute_visibility_point(matrix, value, pivot, enum, type) do
    max = 
      enum
      |> Enum.count()

    streak = 
      enum
      |> Enum.take_while(fn pointer -> 
        get_matrix_point(matrix, pivot, pointer, type) < value
      end)
      |> Enum.count()

    min(streak + 1, max)
  end

  defp get_matrix_point(matrix, pivot, pointer, type \\ :horizontal)

  defp get_matrix_point(matrix, pivot, pointer, :vertical) do
    matrix
    |> elem(pointer)
    |> elem(pivot)
  end

  defp get_matrix_point(matrix, pivot, pointer, _) do
    matrix
    |> elem(pivot)
    |> elem(pointer)
  end

  defp max_of_matrix(matrix) do
    Tuple.to_list(matrix)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.max/1) 
    |> Enum.max()
  end
end
