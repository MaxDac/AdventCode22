defmodule Calc do
  @moduledoc false

  def compute(input \\ "test_input", dimension \\ 20) do
    coordinates =
      input
      |> Input.read()
    
    items_coordinates = 
      coordinates
      |> Enum.flat_map(&(&1))

    maxes = 
      items_coordinates
      |> get_max_min()

    coordinates
    |> Enum.map(fn [sensor, beacon] -> {sensor, beacon, Distance.compute_manhattan_distance(sensor, beacon)} end) 
    |> Distance.compute_row(dimension)
  end

  defp not_member(list, element), do: not(Enum.member?(list, element))

  defp distinct(list) do
    list
    |> MapSet.new()
    |> MapSet.to_list()
  end

  defp get_max_min(coordinates) do
    {xes, yes} = {
      Enum.map(coordinates, fn {x, _} -> x end),
      Enum.map(coordinates, fn {_, y} -> y end)
    }

    {
      Enum.min(xes),
      Enum.max(xes),
      Enum.min(yes),
      Enum.max(yes)
    }
  end

  defp filter_coordinates(coordinates, maxes)
  defp filter_coordinates({x, _}, {min_x, max_x, _, _}) when x < min_x or x > max_x, do: false
  defp filter_coordinates({_, y}, {_, _, min_y, max_y}) when y < min_y or y > max_y, do: false
  defp filter_coordinates(_, _), do: true
end
