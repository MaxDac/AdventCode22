defmodule Calc do
  @moduledoc false

  def compute(input \\ "test_input") do
    map =
      Input.get_input(input)

    [{_, first} | _] =
      map
      |> Map.to_list()

    map
    |> NetworkMap.act(first)
  end
end
