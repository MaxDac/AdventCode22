defmodule PriorityQueue do
  @moduledoc false

  def new, do: []

  def add(queue, element, acc \\ [])

  def add([], element, acc), do: Enum.reverse(acc) ++ [element]

  def add([e1 = {p1, _} | rest], e2 = {p2, _}, acc) when p1 < p2 do
    add(rest, e2, [e1 | acc])
  end

  def add(queue, element, acc) do
    Enum.reverse(acc) ++ [element] ++ queue
  end
end
