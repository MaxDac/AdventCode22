defmodule Matrix do
  @moduledoc """
  The matrix will be creates with x and y inverted, meaning that each lines container will be x, and the
  lines will traverse the y coordinates.
  To facilitate insertion of the rocks, the matrix will initially be a tuple of tuples, but then the lines, 
  traversing the y coordinates instead of the x, will be converted to lists.
  """
  
  @type t() :: Tuple.t(list(binary()))

  def new(max_x, max_y) do
    1..max_x
    |> Enum.map(fn _ -> build_tuple_line(max_y) end)
    |> List.to_tuple()
  end

  defp build_tuple_line(max_y) do
    1..max_y
    |> Enum.map(fn _ -> "." end)
    |> List.to_tuple()
  end

  @doc """
  Puts the rocks, represented by the coordinates in input, on the grid.
  """
  def put_coordinates_on_grid(grid, _, []), do: grid
  def put_coordinates_on_grid(grid, min_x, [line | rest]) do
    grid
    |> put_coordinate_line_on_grid(min_x, line)
    |> put_coordinates_on_grid(min_x, rest)
  end

  defp put_coordinate_line_on_grid(grid, _, []), do: grid
  
  # One coordinate remaining, but it was already considered to build the previous line
  defp put_coordinate_line_on_grid(grid, _, [_]), do: grid

  # Line moving along the y axis
  defp put_coordinate_line_on_grid(grid, min_x, [{x, y1} | rest = [{x, y2} | _]]) do
    y1..y2
    |> Enum.reduce(grid, fn y, grid -> update_grid_element(grid, x - min_x, y, "#") end)
    |> put_coordinate_line_on_grid(min_x, rest)
  end

  defp put_coordinate_line_on_grid(grid, min_x, [{x1, y} | rest = [{x2, y} | _]]) do
    x1..x2
    |> Enum.reduce(grid, fn x, grid -> update_grid_element(grid, x - min_x, y, "#") end)
    |> put_coordinate_line_on_grid(min_x, rest)
  end

  defp update_grid_element(grid, x, y, element) do
    new_line = 
      grid
      |> elem(x)
      |> Tuple.delete_at(y)
      |> Tuple.insert_at(y, element)

    grid
    |> Tuple.delete_at(x)
    |> Tuple.insert_at(x, new_line)
  end

  def grid_line_to_list(grid) do
    length = tuple_size(grid)

    1..length
    |> Enum.reduce(grid, &update_grid_line/2)
  end

  defp update_grid_line(i, grid) do
    new_line = 
      grid
      |> elem(i - 1)
      |> Tuple.to_list()

    grid
    |> Tuple.delete_at(i - 1)
    |> Tuple.insert_at(i - 1, new_line)
  end

  def update_grid_at(grid, at, substitution) when is_function(substitution) do
    new_line = 
      grid
      |> elem(at)
      |> substitution.()

    grid
    |> Tuple.delete_at(at)
    |> Tuple.insert_at(at, new_line)
  end

  def update_grid_at(grid, at, new_line) do
    grid
    |> Tuple.delete_at(at)
    |> Tuple.insert_at(at, new_line)
  end
end

