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

  defp compute_manhattan_distance({ax, ay}, {bx, by}) do
    abs(ax - bx) + abs(ay - by)
  end
end
