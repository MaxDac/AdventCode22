defmodule Calc do
  @moduledoc false

  def compute(input \\ "test_input") do
    grid =
      input
      |> Input.get_input()
      |> Grid.new()

    {steps, path} =
      grid
      |> Grid.get_quickest_way()
      |> IO.inspect()

    {width, height} = {
      tuple_size(grid |> elem(0)),
      tuple_size(grid),
    }

    path
    |> Draw.draw(width, height)
  end
end
