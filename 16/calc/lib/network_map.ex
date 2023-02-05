defmodule NetworkMap do
  @moduledoc false

  @max_steps 30
  @check_treshold 5

  defstruct value: "",
            rate: 0,
            valves: []

  @type t() :: %__MODULE__{
    value: binary(),
    rate: integer(),
    valves: list(binary())
  }

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

  @spec act(
    map :: Map.t(NetworkMap.t()), 
    current :: binary(), 
    from :: list(binary()), 
    step :: non_neg_integer()) :: non_neg_integer()
  def act(map, current, from \\ [], step \\ 0)
  
  def act(_, _, from, @max_steps) do
    compute_released(from)
  end

  def act(map, current, from, step) do
    # Going recursively to every possible steps:
    # Possibility 1: release the valve. This can happen only when the valve has not been released
    # Possibility 2: spend the minute going in another direction. In this case, the valve is not released.

    %{
      rate: pressure,
      valves: current_valves
    } = map[current]

    releasing =
      if not(current |> has_been_released?(from)) do
        new_from = [%NetworkStep{
          step: step + 1,
          valve_name: current,
          pressure: pressure,
          releasing: true
        } | from]
        
        act(map, current, new_from, step + 1)
      else
        0
      end

    new_from = [%NetworkStep{
      step: step + 1,
      valve_name: current,
      pressure: pressure
    } | from]

    paths = 
      current_valves
      |> Enum.map(&act(map, &1, new_from, step + 1))

    Enum.max([releasing | paths])
  end

  @doc """
  Computes the released pressure based on the steps taken.
  The steps params are a list of tuples, containing the information about the steps taken.
  """
  @spec compute_released(steps :: list(NetworkStep.t())) :: non_neg_integer()
  def compute_released(steps, acc \\ 0)

  def compute_released([], acc), do: acc

  def compute_released([%{pressure: 0} | rest], acc), do: compute_released(rest, acc)

  def compute_released([%{releasing: false} | rest], acc), do: compute_released(rest, acc)
    
  def compute_released([%{step: step, pressure: pressure} | rest], acc) do
    # Computing the total release pressure by multiplying the pressure of the valve by the difference between the
    # maximum steps possible and the steps taken to get there.
    # Consider that registering the releasing at turn `n` means that it would actually start releasing after that turn.
    # For instance, considering max steps as 3, if the first step as a movement, and the second as releasing the valve,
    # this means that the total release would be equal to max_steps (3) - stet_at_release (2) = 1, times the gas 
    # released per minute.

    compute_released(rest, (@max_steps - step) * pressure + acc)
  end

  def has_been_released?(valve, from) do
    from
    |> Enum.any?(fn 
      %{valve_name: ^valve, releasing: true} -> true
      _ -> false
    end)
  end
end
