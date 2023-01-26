defmodule Calc do
  @moduledoc """
  Documentation for `Calc`.
  """

  def compute(input \\ "test_input") do
    {_, result} = 
      Input.parse_input(input)
      |> Enum.map(fn 
        "" -> nil
        x -> 
          {evaluated, _} = Code.eval_string(x)
          evaluated
      end)
      |> Comparison.build_comparisons()
      |> Enum.reduce({1, 0}, fn el, {idx, acc} -> 
        if Comparison.compare(el) == :right do
          {idx + 1, acc + idx}
        else
          {idx + 1, acc}
        end
      end)

    result
  end
end
