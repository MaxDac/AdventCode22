defmodule Calc do
  def compute() do
    File.read!("input")
    |> get_marker()
  end

  defp get_marker(string, i \\ 14) do
    case String.split_at(string, 14) do
      {a, _} ->
        length = 
          a
          |> String.split("")
          |> Enum.filter(&filter_empty/1)
          |> MapSet.new()
          |> Enum.count()

        if length == 14 do
          IO.puts "Signal: #{inspect a}"
          i
        else
          {_, rest} = String.split_at(string, 1)
          get_marker(rest, i + 1)
        end
    end
  end

  defp filter_empty(""), do: false
  defp filter_empty(nil), do: false
  defp filter_empty(_), do: true
end
