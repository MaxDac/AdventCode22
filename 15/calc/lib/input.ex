defmodule Input do
  @moduledoc false

  @value_regex ~r/x=(-?\d+),\s+y=(-?\d+)/

  def read(input) do
    input
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&read_line/1)
  end
  
  defp read_line(line) do
    Regex.scan(@value_regex, line)
    |> Enum.map(fn [_, x, y] -> {String.to_integer(x), String.to_integer(y)} end)
  end
end
