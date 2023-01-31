defmodule RowRangeTest do
  use ExUnit.Case

  test "range subtract successfully when contained" do
    assert {10, [{0, 4}, {7, 10}]} = RowRange.subtract({10, [{0, 10}]}, {5, 6})
  end

  test "range subtract successfully when not contained 1" do
    assert {10, [{0, 1}, {7, 10}]} = RowRange.subtract({10, [{0, 4}, {7, 10}]}, {2, 6})
  end

  test "range subtract successfully when not contained 2" do
    assert {10, [{0, 4}, {9, 10}]} = RowRange.subtract({10, [{0, 4}, {7, 10}]}, {5, 8})
  end

  test "range subtract successfully when overlapping two ranges" do
    assert {10, [{0, 2}, {9, 10}]} = RowRange.subtract({10, [{0, 4}, {7, 10}]}, {3, 8})
  end

  test "range subtract successfully when off the inferior limit" do
    assert {10, [{7, 10}]} = RowRange.subtract({10, [{0, 10}]}, {-1, 6})
  end

  test "range subtract successfully when off the superior limit" do
    assert {10, [{0, 5}]} = RowRange.subtract({10, [{0, 10}]}, {6, 11})
  end
end
