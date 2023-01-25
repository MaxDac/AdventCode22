defmodule Comparison do
  @moduledoc false

  defstruct first: nil,
            second: nil

  def new(first, second), do: 
    %Comparison{first: first, second: second}

  def build_comparisons(evaluated, acc \\ [])

  def build_comparisons([], acc), do: 
    Enum.reverse(acc)

  def build_comparisons([nil | rest], acc), do: 
    build_comparisons(rest, acc)

  def build_comparisons([first | [second | rest]], acc) do
    build_comparisons(rest, [Comparison.new(first, second) | acc])
  end

  def compare(%{first: [], second: []}), do: :equal

  def compare(%{first: [], second: _}), do: :right
  
  def compare(%{first: _, second: []}), do: :wrong

  def compare(%{
    first: [first | first_rest], 
    second: [second | second_rest]}) when is_integer(first) and is_integer(second) do
    case {first, second} do
      {f, s} when f > s -> :wrong
      {f, s} when f < s -> :right
      _ -> compare(%{first: first_rest, second: second_rest})
    end
  end

  def compare(%{
    first: [first | first_rest], 
    second: [second | second_rest]}) when is_list(first) and is_list(second) do
    case compare(%{first: first, second: second}) do
      :equal -> compare(%{first: first_rest, second: second_rest})      
      other -> other
    end
  end

  def compare(%{
    first: [first | first_rest], 
    second: [second | second_rest]}) when is_integer(first) do
    case compare(%{first: [first], second: second}) do
      :equal -> compare(%{first: first_rest, second: second_rest})      
      other -> other
    end
  end

  def compare(%{
    first: [first | first_rest], 
    second: [second | second_rest]}) do
    case compare(%{first: first, second: [second]}) do
      :equal -> compare(%{first: first_rest, second: second_rest})      
      other -> other
    end
  end
end
