defmodule Grid do
  @moduledoc """
  Represents the grid.
  The grid is represented by a tuple, representing the y axis, that contains a series of tuples,
  representing the x axis.
  The x axis traverses each tuple inside the tuple from left to right.
  The y axis traverses the main tuple from top to bottom, instead of the classic "cartesian way".

  +--> x
  |
  v
  y
  """

  @starting_position 83
  @ending_position 69

  @lowest_height 97
  @highest_height 122

  @max_possible 100_000_000

  def new(list_matrix) do
    list_matrix
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

  def get_starting_position(grid) do
    get_first_occurrence(grid, @starting_position)
  end

  def get_ending_position(grid) do
    get_first_occurrence(grid, @ending_position)
  end

  defp get_first_occurrence(grid, element, y \\ 0) do
    case grid |> elem(y) |> get_element_in_tuple(element) do
      nil -> get_first_occurrence(grid, element, y + 1)
      x -> {x, y}
    end
  end

  defp get_element_in_tuple(tuple, element, i \\ 0) do
    if tuple_size(tuple) == i do
      nil
    else
      if tuple |> elem(i) == element do
        i
      else
        get_element_in_tuple(tuple, element, i + 1)
      end
    end
  end

  def get_quickest_way(grid) do
    starting_position = get_starting_position(grid)
    ending_position = get_ending_position(grid)
    grid_width = grid |> elem(0) |> tuple_size()
    grid_height = grid |> tuple_size()

    {number_of_steps, path} =
      get_quickest_way(grid, grid_width, grid_height, starting_position, ending_position)

    {number_of_steps, path |> Enum.reverse()}
  end

  defp get_quickest_way(grid, grid_width, grid_height, start_position, end_position, from \\ [])
  defp get_quickest_way(_, _, _, {-1, _}, _, from), do: {nil, from}
  defp get_quickest_way(_, _, _, {_, -1}, _, from), do: {nil, from}
  defp get_quickest_way(_, _, _, {x, y}, {x, y}, from), do: {1, from}
  defp get_quickest_way(grid, grid_width, grid_height, start_position = {start_x, start_y}, {end_x, end_y}, from) do
    {current, up, down, left, right} = {
      get_grid_height(grid, grid_width, grid_height, start_x, start_y),
      get_grid_height(grid, grid_width, grid_height, start_x, start_y - 1),
      get_grid_height(grid, grid_width, grid_height, start_x, start_y + 1),
      get_grid_height(grid, grid_width, grid_height, start_x - 1, start_y),
      get_grid_height(grid, grid_width, grid_height, start_x + 1, start_y),
    }

    [
      fn -> if check_way(current, up, from, {start_x, start_y - 1}) do get_quickest_way(grid, grid_width, grid_height, {start_x, start_y - 1}, {end_x, end_y}, [start_position | from]) else {nil, from} end end,
      fn -> if check_way(current, down, from, {start_x, start_y + 1}) do get_quickest_way(grid, grid_width, grid_height, {start_x, start_y + 1}, {end_x, end_y}, [start_position | from]) else {nil, from} end end,
      fn -> if check_way(current, left, from, {start_x - 1, start_y}) do get_quickest_way(grid, grid_width, grid_height, {start_x - 1, start_y}, {end_x, end_y}, [start_position | from]) else {nil, from} end end,
      fn -> if check_way(current, right, from, {start_x + 1, start_y}) do get_quickest_way(grid, grid_width, grid_height, {start_x + 1, start_y}, {end_x, end_y}, [start_position | from]) else {nil, from} end end
    ]
    |> Enum.map(&Task.async/1)
    |> Enum.map(&Task.await/1)
    |> Enum.map(fn
      {nil, from} -> {@max_possible, from}
      {x, from} -> {x + 1, from}
    end)
    |> min_of(fn {x, _} -> x end)
  end

  defp check_way(_, nil, _, _), do: false
  defp check_way(current, next, from, next_position) do
    not(Enum.member?(from, next_position)) && (next == current + 1 || next == current)
  end

  def get_grid_height(_, _, _, -1, _), do: nil
  def get_grid_height(_, _, _, _, -1), do: nil
  def get_grid_height(_, width, _, x, _) when x >= width, do: nil
  def get_grid_height(_, _, height, _, y) when y >= height, do: nil
  def get_grid_height(grid, _, _, x, y) do
    grid
    |> elem(y)
    |> elem(x)
    |> correct_starting_ending_positions()
  end

  defp correct_starting_ending_positions(@starting_position), do: @lowest_height
  defp correct_starting_ending_positions(@ending_position), do: @highest_height
  defp correct_starting_ending_positions(x), do: x

  defp min_of(list, f)
  defp min_of([], _), do: nil
  defp min_of([elem], _), do: elem
  defp min_of([first | [second | rest]], f) do
    case {f.(first), f.(second)} do
      {a, b} when a < b -> min_of([first | rest], f)
      _ -> min_of([second | rest], f)
    end
  end
end
