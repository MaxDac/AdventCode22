defmodule RowRange do
  @type t() :: {non_neg_integer(), list({non_neg_integer(), non_neg_integer()})}

  def new(dimension) do
    {dimension, [{0, dimension}]}
  end

  def subtract(row_range, range, acc \\ [])
  def subtract(row_range, {a, b}, acc) when a < 0 do 
    acc |> deb(label: "first")
    subtract(row_range, {0, b}, acc)
  end

  def subtract(row_range = {max, _}, {a, b}, acc) when b > max do 
    acc |> deb(label: "second")
    subtract(row_range, {a, max}, acc)
  end

  # Exit condition: array empty
  def subtract({d, []}, _, acc) do
    deb(acc, label: "empty-1")
    {d, Enum.reverse(acc)}
  end
  
  # Exit condition: range alredy passed
  def subtract({d, rest = [{a, _} | _]}, {_, rb}, acc) when a > rb do
    deb(acc, label: "exit-1")
    deb(rest, label: "exit-2")
    {d, Enum.reverse(acc) ++ rest}
  end

  # No action needed, range to subtract is superior
  def subtract({d, [{a, b} | rest]}, {ra, rb}, acc) when b < ra do
    deb({a, b}, label: "superior-0")
    deb(acc, label: "superior-1")
    deb(rest, label: "superior-2")
    subtract({d, rest}, {ra, rb}, [{a, b} | acc])
  end

  # row_range contained
  def subtract({d, [{a, b} | rest]}, {ra, rb}, acc) when a >= ra and b <= rb do
    deb(acc, label: "third")
    deb(rest, label: "fourth")
    subtract({d, rest}, {ra, rb}, acc)
  end

  # range contained
  def subtract({d, [{a, b} | rest]}, {ra, rb}, acc) when a <= ra and b >= rb do
    deb(acc, label: "5")
    deb(rest, label: "6")

    first_item = if a >= ra, do: [], else: [{a, ra - 1}]
    second_item = if b <= rb, do: [], else: [{rb + 1, b}]

    new_ranges =
      [first_item, second_item]
      |> Enum.flat_map(&(&1))

    {d, Enum.reverse(acc) ++ new_ranges ++ rest}
  end

  # range partially contained
  # range:      |---|
  # row_range:    |---|
  def subtract({d, [{a, b} | rest]}, {ra, rb}, acc) when a <= ra and b >= ra do
    deb(acc, label: "7")
    deb(rest, label: "8")
    subtract({d, rest}, {ra, rb}, [{a, ra - 1} | acc])
  end

  # range partially contained
  # range:       |---|
  # row_range: |---|
  def subtract({d, [{a, b} | rest]}, {ra, rb}, acc) when a <= rb and b >= rb do
    deb(acc, label: "9")
    deb(rest, label: "10")
    subtract({d, rest}, {ra, rb}, [{rb + 1, b} | acc])
  end

  def empty?([]), do: true
  def empty?(_), do: false

  defp deb(item, [label: label]) do
    # IO.inspect(item, label: label)
  end
end
