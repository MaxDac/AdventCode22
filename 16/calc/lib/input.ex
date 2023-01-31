defmodule Input do
  @moduledoc false

  @phrase_match ~r/Valve (?<Value>\w+) has flow rate=(?<rate>\d+); (tunnel|tunnels) lead(s)? to valve(s)? (?<valve>\w+(,\s\w+)*|\w+)/

  def get_input(input) do
    input
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
    |> Map.new(fn row -> {row.value, row} end)
  end

  defp parse_row(row) do
    %{
      "Value" => value, 
      "rate" => rate, 
      "valve" => valves
    } = Regex.named_captures(@phrase_match, row)

    %NetworkMap{
      value: value,
      rate: String.to_integer(rate),
      valves: String.split(valves, ", ", trim: true)
    }
  end
end
