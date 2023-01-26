defmodule Calc do
  @moduledoc false

  def compute(input \\ "test_input") do
    coordinates =
      Input.get_lines(input)
      
    {{min_x, max_x}, {_, max_y}} =
      coordinates
      |> Input.get_matrix_size()
      |> IO.inspect(label: "matrix measures")

    Matrix.new(max_x - min_x, max_y)
    |> Matrix.put_coordinates_on_grid(min_x, coordinates)
    |> Matrix.grid_line_to_list()
  end

end
