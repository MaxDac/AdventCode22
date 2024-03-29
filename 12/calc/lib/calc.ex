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

    {ex, ey} = 
      Grid.get_ending_position(grid)
      |> IO.inspect(label: "ending point")

    result =
      grid
      |> Computation.get_quickest_way(buffer_grid, width, height, {0, 22})
    # Step 1
    # |> Grid.get_grid_element(ex, ey)
    # |> Grid.filter(fn %VisibilityMapElement{})
    # Decomment if you want to draw the path
    # |> Draw.draw(width, height)

    # %VisibilityMapElement{
      # steps: total_steps, 
    #  trail: path
    # } = 
      result
      |> Grid.get_grid_element(ex, ey)
      |> IO.inspect()

    # [{_, %VisibilityMapElement{steps: shortest_a}}] =
    #   Grid.merge_grid(grid, result)
    #   |> Grid.filter(fn {height, _} -> height == Grid.get_lowest_height() end)
    #   |> Enum.sort(fn {_, %VisibilityMapElement{steps: steps1}}, {_, %VisibilityMapElement{steps: steps2}} -> steps1 > steps2 end)
    #   |> Enum.take(1)

    # traverse_path_until_a(grid, path)

    Grid.filter_position(grid, fn 
      97 -> true
      _ -> false
    end)
    |> Enum.map(fn position -> Computation.get_quickest_way(grid, Grid.new_buffer(width, height), width, height, position) end)
    |> Enum.map(&Grid.get_grid_element(&1, ex, ey))
    |> Enum.filter(fn 
      nil -> false
      _ -> true
    end)
    |> Enum.map(fn %VisibilityMapElement{steps: steps} -> steps end)
    |> Enum.min()
  end

  defp traverse_path_until_a(grid, path, counter \\ 0)
  defp traverse_path_until_a(_, [], _), do: nil
  defp traverse_path_until_a(grid, [{x, y} | path], counter) do
    case Grid.get_grid_element(grid, x, y) do
      97 -> counter
      _ -> traverse_path_until_a(grid, path, counter + 1)
    end
  end
end
