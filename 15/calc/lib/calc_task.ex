defmodule Mix.Tasks.CalcTask do
  @moduledoc false

  use Mix.Task

  @impl Mix.Task
  def run(_) do
    Calc.compute()
  end
end
