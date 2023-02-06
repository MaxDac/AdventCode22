defmodule NetworkMap do
  @moduledoc false

  defstruct value: "",
            rate: 0,
            valves: []

  @type t() :: %__MODULE__{
    value: binary(),
    rate: integer(),
    valves: list(binary())
  }
end
