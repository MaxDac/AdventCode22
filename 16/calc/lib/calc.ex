defmodule Calc do
  @moduledoc false

  def compute(input \\ "test_input") do
    map =
      Input.get_input(input)

    [{first, _} | _] =
      map
      |> Map.to_list()

    {result, path} =
      map
      |> PathComputation.act(first)

    {result, path |> Enum.reverse()}
  end
end
