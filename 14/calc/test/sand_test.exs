defmodule SandTest do
  use ExUnit.Case

  setup do
    coordinates = Input.get_lines("test_input")

    {{min_x, max_x}, {_, max_y}} =
      coordinates
      |> Input.get_matrix_size()

    grid =
      Matrix.new(max_x - min_x, max_y)
      |> Matrix.put_coordinates_on_grid(min_x, coordinates)
      |> Matrix.grid_line_to_list()

    [
      grid: grid,
      max_x: max_x,
      min_x: min_x
    ]
  end

  test "split_grid_column_at works with filled grid", %{
    grid: grid,
    max_x: max_x,
  } do
    {free, filled} =
      Sand.split_grid_column_at(grid, max_x, 2)

    assert length(free) == 6
    assert length(filled) == 4
  end

  test "split_grid_column_at returns nil when out of inferior bound", %{
    grid: grid,
    max_x: max_x,
  } do
    assert nil == Sand.split_grid_column_at(grid, max_x, -1)
  end

  test "split_grid_column_at returns nil when out of superior bound", %{
    grid: grid,
    max_x: max_x,
  } do
    assert nil == Sand.split_grid_column_at(grid, max_x, max_x)
  end

  test "split_grid_column_at works with filled grid, and offset", %{
    grid: grid,
    max_x: max_x,
  } do
    {free, filled} =
      Sand.split_grid_column_at(grid, max_x, 2, 3)

    assert length(free) == 2
    assert length(filled) == 1
  end

  test "upgrade_matrix_line will update the matrix line correctly", %{
    grid: grid,
    max_x: max_x,
  } do
    line = elem(grid, 2)
    {free, filled} = 
      Sand.split_grid_column_at(grid, max_x, 2)

    new_line =
      Sand.upgrade_matrix_line(grid, 2, free, filled)
      |> elem(2)

    assert length(new_line) == length(line)
    assert [".", ".", ".", ".", ".", "o", "#", ".", ".", "#"] == new_line
  end


end

