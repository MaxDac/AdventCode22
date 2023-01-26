defmodule Input do
  @moduledoc false

  @grid_measure_coefficient 1

  def get_lines(input) do
    input
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(&is_not_null_nor_empty/1)
    |> Enum.map(&get_coordinates/1)
  end

  defp is_not_null_nor_empty(nil), do: false
  defp is_not_null_nor_empty(""), do: false
  defp is_not_null_nor_empty(_), do: true

  defp get_coordinates(line) do
    line
    |> String.split(" -> ")
    |> Enum.filter(&is_not_null_nor_empty/1)
    |> Enum.map(fn coords ->
      [x, y] = 
        coords
        |> String.split(",")
        |> Enum.filter(&is_not_null_nor_empty/1)
        |> Enum.map(&String.to_integer/1)
      {x, y}
    end)
  end

  def get_matrix_size(coordinates) do
    xes = 
      coordinates
      |> Enum.flat_map(fn line -> Enum.map(line, fn {x, _} -> x end) end)

    yes = 
      coordinates
      |> Enum.flat_map(fn line -> Enum.map(line, fn {_, y} -> y end) end)

    [min_x, min_y] = 
      [Enum.min(xes), Enum.min(yes)]
      |> Enum.map(fn m -> div(m, @grid_measure_coefficient) * @grid_measure_coefficient end)

    [max_x, max_y] = 
      [Enum.max(xes), Enum.max(yes)]
      |> Enum.map(fn m -> div(m, @grid_measure_coefficient) * @grid_measure_coefficient + @grid_measure_coefficient end)
    
    {{min_x, max_x}, {min_y, max_y}}
  end
end
