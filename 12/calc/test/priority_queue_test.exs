defmodule PriorityQueueTest do
  use ExUnit.Case

  test "Adds lesser priority correctly 1" do
    queue = 
      [{1, "a"}]
      |> PriorityQueue.add({2, "b"})

    [first | [second | _]] = queue

    assert {1, _} = first
    assert {2, _} = second
  end

  test "Adds lesser priority correctly 2" do
    queue = 
      [{1, "a"}]
      |> PriorityQueue.add({2, "b"})
      |> PriorityQueue.add({5, "d"})
      |> PriorityQueue.add({0, "e"})
      |> PriorityQueue.add({3, "c"})

    first = Enum.at(queue, 0)
    middle = Enum.at(queue, 2)
    last = Enum.at(queue, 4)

    assert {0, "e"} = first
    assert {5, "d"} = last
    assert {2, "b"} = middle
  end
end
