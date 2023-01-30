defmodule Calc do
  @moduledoc false

  def compute(input \\ "test_input", selected_y \\ 10) do
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
    |> Enum.map(fn [sensor, beacon] ->
      Task.async(fn -> Distance.compute_distance(sensor, beacon) end)
    end)
    |> Enum.flat_map(&Task.await(&1))
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.filter(fn {_, y} -> y == selected_y end)
    |> Enum.filter(&filter_coordinates(&1, maxes))
    |> Enum.filter(&not_member(items_coordinates, &1))
    |> Enum.count()
  end

  defp not_member(list, element), do: not(Enum.member?(list, element))

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
