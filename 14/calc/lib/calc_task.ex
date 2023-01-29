defmodule Mix.Tasks.CalcTask do
  use Mix.Task
  
  @impl Mix.Task
  def run(_), do: Calc.compute()

end
