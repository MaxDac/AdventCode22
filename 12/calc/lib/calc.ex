defmodule Calc do
  @moduledoc false

  def compute(input \\ "test_input") do
    grid =
      input
      |> Input.get_input()
      |> Grid.new()

    {width, height} = {
      tuple_size(grid |> elem(0)),
      tuple_size(grid),
    }

    buffer_grid = 
      Grid.new_buffer(width, height) 

    grid
    |> Computation.get_quickest_way(buffer_grid, width, height)
    # Decomment if you want to draw the path
    # |> Draw.draw(width, height)
  end
end
