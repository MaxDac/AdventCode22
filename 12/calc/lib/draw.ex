defmodule Draw do
  @moduledoc false

  def draw(path, grid_width, grid_height) do
    get_empty_grid(grid_width, grid_height)
    |> traverse_path(path)
  end

  defp traverse_path(grid, []), do: grid

  defp traverse_path(grid, [{x, y}]) do
    traverse_path(update_grid_char(grid, x, y, "X"), [])
  end

  defp traverse_path(grid, [current | [next | rest]]) do
    case {current, next} do
      {{x, y1}, {x, y2}} when y1 > y2 ->
        traverse_path(update_grid_char(grid, x, y1, "^"), [next | rest])
      {{x, y1}, {x, _}} ->
        traverse_path(update_grid_char(grid, x, y1, "v"), [next | rest])
      {{x1, y}, {x2, y}} when x1 > x2 ->
        traverse_path(update_grid_char(grid, x1, y, "<"), [next | rest])
      {{x1, y}, {_, y}} ->
        traverse_path(update_grid_char(grid, x1, y, ">"), [next | rest])
    end
  end

  defp get_empty_grid(width, height) do
    1..height
    |> Enum.map(fn _ -> 1..width |> Enum.map(fn _ -> "." end) |> List.to_tuple() end)
    |> List.to_tuple()
  end

  defp update_grid_char(grid, x, y, character) do
    new_row =
      grid
      |> elem(y)
      |> Tuple.delete_at(x)
      |> Tuple.insert_at(x, character)

    grid
    |> Tuple.delete_at(y)
    |> Tuple.insert_at(y, new_row)
  end
end
