defmodule Calc do
  @moduledoc """
  Documentation for `Calc`.
  """

  def compute(input \\ "test_input") do
    input
    |> Input.get_input()
    |> Operations.compute_commands_list()
    # |> Operations.compute_signal_strength()
    |> DrawCrt.draw_crt()
    |> DrawCrt.draw()
  end
end
