defmodule NetworkMap do
  @moduledoc false

  defstruct value: "",
            rate: 0,
            valves: []

  @type t() :: %__MODULE__{
    value: binary(),
    rate: integer(),
    valves: list(binary())
  }

  @max_steps 30

  def act(map, current, from \\ nil, step \\ 0, released \\ [])

  def act(_, _, _, @max_steps, released), do: get_pressure_released(released)
  
  def act(map, current = %{value: value, rate: 0, valves: valves}, from, step, released) do
    valves
    |> Enum.filter(&filter_from(&1, from))
    |> Enum.map(&act(map, map[&1], current, step + 1, [{value, step + 1, 0} | released]))
    # |> IO.inspect(label: "Walking value 2 at: #{inspect step}")
    |> get_max()
  end

  def act(map, current = %{value: value, rate: rate}, from, step, released) do
    releasing_values =
      case {made_step?(released), already_passed?(value, released)} do
        {_, true} -> []
        {false, _} -> []
        _ ->
          [act(map, current, from, step + 1, [{value, step + 1, rate} | released])]
      end
      # |> IO.inspect(label: "Releasing value at #{inspect step}")

    walking_value = 
      act(map, %NetworkMap{current | rate: 0}, from, step, released)
      # |> IO.inspect(label: "Walking value at #{inspect step}")

    [walking_value | releasing_values]
    |> get_max()
  end

  defp filter_from(_, nil), do: true
  defp filter_from(item, %{value: value}), do: item != value

  defp get_pressure_released(released) do
    result =
      released
      |> Enum.reduce(0, fn {_, step, value}, acc -> acc + value * (@max_steps - step) end)

    {result, released}
  end

  defp made_step?([{_, _, 0} | _]), do: true
  defp made_step?(_), do: false

  defp already_passed?(location, path) do
    path
    |> Enum.any?(fn 
      {^location, _, value} when value > 0 -> true
      _ -> false
    end)
  end

  defp get_max([]), do: {0, []}
  defp get_max(list), do: 
    list
    |> Enum.max(fn {val1, _}, {val2, _} -> val1 > val2 end)
end
