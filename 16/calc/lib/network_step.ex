defmodule NetworkStep do
  defstruct step: 0,
            valve_name: "",
            pressure: 0,
            releasing: false

  @type t() :: %__MODULE__{
    step: non_neg_integer(),
    valve_name: binary(),
    pressure: non_neg_integer(),
    releasing: boolean()
  }
end
