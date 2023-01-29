defmodule Calc do
  @moduledoc false

  def compute(input \\ "test_input") do
    coordinates =
      Input.get_lines(input)
      
    {{min_x, max_x}, {_, max_y}} =
      coordinates
      |> Input.get_matrix_size()
      |> IO.inspect(label: "matrix measures")

    # Let's consider a matrix with an x size with two additional columns at the border, to consider the void
    # {min_x, max_x} = {min_x - 1, max_x + 1}

    # For the second task, considering a floor two units below the minimum, where the base total size will be two 
    # times the maximum height, considering that to the maximum fill the sand pyramid will be two square triangles.
    # **Note**: the height will be two sizes more than the one computed, for the added floor.
    x_offset = (max_y + 2) * 2 - (max_x - min_x)
    {min_x, max_x} = {min_x - x_offset + 2, max_x + x_offset + 2}

    Matrix.new(max_x - min_x, max_y)
    |> Matrix.put_coordinates_on_grid(min_x, coordinates)
    |> Matrix.grid_line_to_list()
    |> map()
    # |> IO.inspect(label: "initial grid")
    |> Sand.sand_grain(min_x, max_x, max_y + 2)
    |> IO.inspect(label: "result")
  end

  def map(matrix) do
    length = tuple_size(matrix)
    new_matrix = 1..length |> Enum.map(fn _ -> [] end) |> List.to_tuple()

    {_, result} =
      Enum.reduce(matrix |> Tuple.to_list(), {0, new_matrix}, fn column, {index, new_matrix} -> 
        new_column = column ++ [".", "#"]
        {index + 1, Matrix.update_grid_at(new_matrix, index, new_column)}
      end)

    result
  end
end
