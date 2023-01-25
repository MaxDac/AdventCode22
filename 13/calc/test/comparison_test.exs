defmodule ComparisonTest do
  use ExUnit.Case

  test "comparison1" do
    comparison = Comparison.new([1,1,3,1,1], [1,1,5,1,1])
    assert Comparison.compare(comparison) == :right
  end

  test "comparison2" do
    comparison = Comparison.new([[1],[2,3,4]], [[1],4])
    assert Comparison.compare(comparison) == :right
  end

  test "comparison3" do
    comparison = Comparison.new([9], [[8,7,6]])
    assert Comparison.compare(comparison) == :wrong
  end

  test "comparison4" do
    comparison = Comparison.new([[4,4],4,4], [[4,4],4,4,4])
    assert Comparison.compare(comparison) == :right
  end

  test "comparison5" do
    comparison = Comparison.new([7,7,7,7], [7,7,7])
    assert Comparison.compare(comparison) == :wrong
  end

  test "comparison6" do
    comparison = Comparison.new([], [3])
    assert Comparison.compare(comparison) == :right
  end

  test "comparison7" do
    comparison = Comparison.new([[[]]], [[]])
    assert Comparison.compare(comparison) == :wrong
  end

  test "comparison8" do
    comparison = Comparison.new([1,[2,[3,[4,[5,6,7]]]],8,9], [1,[2,[3,[4,[5,6,0]]]],8,9])
    assert Comparison.compare(comparison) == :wrong
  end
end
