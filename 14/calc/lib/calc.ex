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
    {min_x, max_x} = {min_x - 1, max_x + 1}

    Matrix.new(max_x - min_x, max_y)
    |> Matrix.put_coordinates_on_grid(min_x, coordinates)
    |> Matrix.grid_line_to_list()
    |> IO.inspect(label: "initial grid")
    |> Sand.sand_grain(min_x, max_x, max_y)
    |> IO.inspect(label: "result")
  end

end
