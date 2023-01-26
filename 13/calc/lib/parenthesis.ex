defmodule Parenthesis do
  defstruct type: "",
            number: 1

  def new("["), do: %Parenthesis{type: "["}
  def new("]"), do: %Parenthesis{type: "]"}
end
