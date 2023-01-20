defmodule Calc do
  def compute() do
    {:ok, input} = File.read("input") 

    input
    |> String.split("\n")
    |> internal()
  end
  
  defp internal(array, acc \\ [])

  defp internal([], acc) do
    acc
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp internal(["" | rest], acc) do
    internal(rest, [0 | acc])
  end
  
  defp internal([first | rest], []) do
    internal(rest, [parse_int(first)])
  end
  
  defp internal([next | rest], [first | acc]) do
    internal(rest, [first + parse_int(next) | acc])
  end

  defp parse_int(string) do
    case Integer.parse(string) do
      {x, ""} when is_number(x) -> x
    end
  end
end
