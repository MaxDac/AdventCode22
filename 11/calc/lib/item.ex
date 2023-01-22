defmodule Item do
  @moduledoc false

  defstruct initial_value: 0,
            divisible_by: %{}

  def new(value) do
    %Item{
      initial_value: value,
      divisible_by: build_initial_divisible_by(value)
    }
  end
  
  defp build_initial_divisible_by(value) do
    for i <- [2, 3, 5, 7, 11, 13, 17, 19, 23] do {i, rem(value, i)} end
    |> Map.new()
  end

  @doc """
  Updates the item divisible by with the given operation.
  """
  def update_divisibles(item = %{divisible_by: divisible_by}, operation) do
    new_divisible_by =
      divisible_by
      |> Map.new(fn {k, v} -> {k, rem(operation.(v), k)} end)

    %Item{item | divisible_by: new_divisible_by}
  end

  @doc """
  Tests whether the item is divisible by the current test value.
  """
  def test_ok?(_item = %{divisible_by: divisible_by}, test) do
    divisible_by[test] == 0
  end
end
