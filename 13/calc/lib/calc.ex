defmodule Calc do
  @moduledoc """
  Documentation for `Calc`.
  """

  def compute(input \\ "test_input") do
    Input.parse_input(input)
  end
end
