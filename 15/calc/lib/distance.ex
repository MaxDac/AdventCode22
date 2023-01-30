defmodule Distance do
  @moduledoc false

  @type coordinate() :: {integer(), integer()}

  @doc """
  This function computes the points at distance from the sensor (first set of coordinates), including the beacon 
  (the second set of coordinates).
  """
  def compute_distance(sensor_coordinates = {sx, sy}, beacon_coordinates, selected_y) do
    distance = compute_manhattan_distance(sensor_coordinates, beacon_coordinates)

    # Checking previously if there could be any y coordinate available
    if sy - distance <= selected_y and selected_y <= sy + distance do
      for x <- (sx - distance)..(sx + distance),
          compute_manhattan_distance({x, selected_y}, {sx, sy}) <= distance, do: {x, selected_y}
    else
      IO.puts "No coordinates available"
      []
    end
  end

  @doc """
  Part two: instead of computing one line, compute each line at a time, excluding every coordinates scanned by
  the sensor.
  """
  def compute_row(coordinates, y) do
    case generate_row_at(y) |> traverse_coordinates(coordinates) do
      [] -> compute_row(coordinates, y - 1)
      free -> free
    end
  end

  defp traverse_coordinates([], _), do: []
  defp traverse_coordinates(row, []), do: row
  defp traverse_coordinates(row, [sensor_coordinate | rest]) do
    row
    |> filter_row_at_distance(sensor_coordinate)
    |> traverse_coordinates(rest)
  end

  defp filter_row_at_distance([], _), do: []
  defp filter_row_at_distance(coordinates = [{_, y} | _], {sensor_coordinates, _, distance}) do
    # IO.inspect(sensor_coordinates, label: "sensor_coordinates")
    case get_sensor_reach_at_y(sensor_coordinates, y, distance) do
      {min, max} ->
        coordinates
        |> Enum.filter(fn {x, _} -> x < min && x > max end)
      _ ->
        coordinates
    end
  end

  defp get_sensor_reach_at_y({sx, sy}, y, distance) do
    # IO.inspect(distance, label: "get_sensor_reach_at_y - distance")
    # IO.inspect(y, label: "get_sensor_reach_at_y - y")
    # IO.inspect({sx, sy}, label: "get_sensor_reach_at_y - {sx, sy}")
    case {abs(sy - y), distance} do
      {a, b} when a < b ->
        half_projection = distance - abs(y - sy)
        {max(0, sx - half_projection), sx + half_projection}
      _ ->
        nil
    end
  end

  def compute_manhattan_distance({ax, ay}, {bx, by}) do
    abs(ax - bx) + abs(ay - by)
  end

  defp generate_row_at(y) do
    0..4_000_000
    |> Enum.map(&{&1, y})
  end
end
