defmodule Draw do
  @moduledoc false

  def draw(%VisibilityMapElement{trail: trail}, width, height), do:
    draw(Enum.reverse(trail), width, height)

  def draw(path, grid_width, grid_height) do
    Grid.get_empty_grid(grid_width, grid_height, ".")
    |> traverse_path(path)
  end

  defp traverse_path(grid, []), do: grid

  defp traverse_path(grid, [{x, y}]) do
    traverse_path(Grid.update_grid_element(grid, x, y, "X"), [])
  end

  defp traverse_path(grid, [current | [next | rest]]) do
    case {current, next} do
      {{x, y1}, {x, y2}} when y1 > y2 ->
        traverse_path(Grid.update_grid_element(grid, x, y1, "^"), [next | rest])
      {{x, y1}, {x, _}} ->
        traverse_path(Grid.update_grid_element(grid, x, y1, "v"), [next | rest])
      {{x1, y}, {x2, y}} when x1 > x2 ->
        traverse_path(Grid.update_grid_element(grid, x1, y, "<"), [next | rest])
      {{x1, y}, {_, y}} ->
        traverse_path(Grid.update_grid_element(grid, x1, y, ">"), [next | rest])
    end
  end
end
