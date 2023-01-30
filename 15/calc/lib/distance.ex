defmodule Distance do
  @moduledoc false

  @type coordinate() :: {integer(), integer()}

  @doc """
  This function computes the points at distance from the sensor (first set of coordinates), including the beacon 
  (the second set of coordinates).
  These coordinates will be added to the MapSet.
  """
  @spec compute_distance(
    sensor_coordinates :: coordinate(),
    beacon_coordinates :: coordinate()
  ) :: list(coordinate())
  def compute_distance(sensor_coordinates = {sx, sy}, beacon_coordinates) do
    distance = compute_manhattan_distance(sensor_coordinates, beacon_coordinates)

    for x <- (sx - distance)..(sx + distance),
        y <- (sy - distance)..(sy + distance), 
        compute_manhattan_distance({x, y}, {sx, sy}) <= distance, do: {x, y}
  end

  defp compute_manhattan_distance({ax, ay}, {bx, by}) do
    abs(ax - bx) + abs(ay - by)
  end
end
