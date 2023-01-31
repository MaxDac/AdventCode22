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

  test "range subtract returns empty array when subtract range exceeds range" do
    assert {10, []} = RowRange.subtract({10, [{10, 10}]}, {5, 15})
  end

  test "range with maximum exceeding but minimum leaving one range intact succeeds" do
    assert {20, [{14, 14}]} = RowRange.subtract({20, [{14, 20}]}, {15, 25})
  end

  test "range with maximum exceeding and minimum equal to the minimum remaining range succeeds" do
    assert {20, []} = RowRange.subtract({20, [{14, 20}]}, {14, 25})
  end

  test "range with minimum exceeding but maximum leaving one range intact succeeds" do
    assert {20, [{14, 14}]} = RowRange.subtract({20, [{0, 14}]}, {-1, 13})
  end

  test "range with minimum exceeding and maximum equal to the minimum remaining range succeeds" do
    assert {20, []} = RowRange.subtract({20, [{0, 14}]}, {-1, 14})
  end

  test "mono-range gets eliminated" do
    assert {20, []} = RowRange.subtract({20, [{0, 0}]}, {0, 14})
  end
end
