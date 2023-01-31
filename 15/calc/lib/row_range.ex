defmodule RowRange do
  @type t() :: {non_neg_integer(), list({non_neg_integer(), non_neg_integer()})}

  def new(dimension) do
    {dimension, [{0, dimension}]}
  end

  def subtract(row_range, range, acc \\ [])
  def subtract(row_range, {a, b}, acc) when a < 0, do: subtract(row_range, {0, b}, acc)
  def subtract(row_range = {max, _}, {a, b}, acc) when b > max, do: subtract(row_range, {a, max}, acc)
  
  # Exit condition: range alredy passed
  def subtract({d, rest = [{a, _} | _]}, {_, rb}, acc) when a >= rb, do: 
    {d, Enum.reverse(acc) ++ rest}

  # row_range contained
  def subtract({d, [{a, b} | rest]}, {ra, rb}, acc) when a >= ra and b <= rb, do: 
    subtract({d, Enum.reverse(acc) ++ rest}, {ra, rb}, acc)

  # range contained
  def subtract({d, [{a, b} | rest]}, {ra, rb}, acc) when a <= ra and b >= rb, do: 
    {d, Enum.reverse(acc) ++ [{a, ra - 1}, {rb + 1, b}] ++ rest}

  # range partially contained
  def subtract({d, [{a, b} | rest]}, {ra, rb}, acc) when b >= ra, do: 
    subtract({d, rest}, {ra, rb}, [{a, ra - 1} | acc])

  # range partially contained
  def subtract({d, [{a, b} | rest]}, {ra, rb}, acc) when a <= rb, do: 
    subtract({d, rest}, {ra, rb}, [{rb + 1, b} | acc])

  def empty?([]), do: true
  def empty?(_), do: false
end
