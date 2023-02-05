defmodule Calc do
  @moduledoc false

  def compute(input \\ "test_input") do
    map =
      Input.get_input(input)

    [{first, _} | _] =
      map
      |> Map.to_list()

    map
    |> NetworkMap.act(first)
  end
end
