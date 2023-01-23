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

  def new(list_matrix) do
    list_matrix
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

  def new_buffer(width, height) do
    1..height
    |> Enum.map(fn _ -> 
      1..width
      |> Enum.map(fn _ -> nil end)
      |> List.to_tuple()
    end)
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

  def get_grid_height(_, _, _, -1, _), do: nil
  def get_grid_height(_, _, _, _, -1), do: nil
  def get_grid_height(_, width, _, x, _) when x >= width, do: nil
  def get_grid_height(_, _, height, _, y) when y >= height, do: nil
  def get_grid_height(grid, _, _, x, y) do
    grid
    |> get_grid_element(x, y)
    |> correct_starting_ending_positions()
  end

  defp correct_starting_ending_positions(@starting_position), do: @lowest_height
  defp correct_starting_ending_positions(@ending_position), do: @highest_height
  defp correct_starting_ending_positions(x), do: x

  def get_grid_element(grid, x, y) do
    grid
    |> elem(y)
    |> elem(x)
  end

  def update_grid_element(grid, x, y, element) do
    new_row =
      grid
      |> elem(y)
      |> Tuple.delete_at(x)
      |> Tuple.insert_at(x, element)

    grid
    |> Tuple.delete_at(y)
    |> Tuple.insert_at(y, new_row)
  end
end
