defmodule Calc do
  def compute() do
    File.read!("input")
    |> String.split("\n")
    |> Enum.filter(fn 
      "" -> false
      nil -> false
      _ -> true
    end)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [a, b] -> {convert(a), convert(convert(a), b)} end)
    |> Enum.map(&determine_points/1)
    |> Enum.sum()
  end
  
  defp convert("A"), do: :rock
  defp convert("B"), do: :paper
  defp convert("C"), do: :scissors

  defp convert(other, "X"), do: loser_of(other)
  defp convert(other, "Y"), do: other
  defp convert(other, "Z"), do: winner_of(other)

  defp winner_of(:rock), do: :paper
  defp winner_of(:paper), do: :scissors
  defp winner_of(:scissors), do: :rock

  defp loser_of(:rock), do: :scissors
  defp loser_of(:paper), do: :rock
  defp loser_of(:scissors), do: :paper

  defp determine_points({:rock, :rock}), do: 3 + 1
  defp determine_points({:rock, :paper}), do: 6 + 2
  defp determine_points({:rock, :scissors}), do: 0 + 3

  defp determine_points({:paper, :rock}), do: 0 + 1
  defp determine_points({:paper, :paper}), do: 3 + 2
  defp determine_points({:paper, :scissors}), do: 6 + 3

  defp determine_points({:scissors, :rock}), do: 6 + 1
  defp determine_points({:scissors, :paper}), do: 0 + 2
  defp determine_points({:scissors, :scissors}), do: 3 + 3
end
