defmodule PathComputation do
  @moduledoc false

  @check_treshold 4
  @max_steps 30

  @spec act(
    map :: Map.t(NetworkMap.t()), 
    current :: binary(), 
    from :: list(binary()), 
    step :: non_neg_integer()) :: non_neg_integer()
  def act(map, current, from \\ [], step \\ 0)
  
  def act(_, _, from, step) when step > @max_steps do
    compute_released(from, from)
  end

  def act(map, current, from, step) do
    # Going recursively to every possible steps:
    # Possibility 1: release the valve. This can happen only when the valve has not been released
    # Possibility 2: spend the minute going in another direction. In this case, the valve is not released.

    if passed_threshold?(from) do
      compute_released(from, from)
    else

      %{
        rate: pressure,
        valves: current_valves
      } = map[current]

      releasing =
        if pressure > 0 && not(current |> has_been_released?(from)) do
          new_from = [%NetworkStep{
            step: step + 1,
            valve_name: current,
            pressure: pressure,
            releasing: true
          } | from]
          
          act(map, current, new_from, step + 1)
        else
          compute_released(from, from)
        end

      new_from = [%NetworkStep{
        step: step + 1,
        valve_name: current,
        pressure: pressure
      } | from]

      paths = 
        current_valves
        |> Enum.map(&act(map, &1, new_from, step + 1))

      [releasing | paths]
      |> Enum.max(fn {x, _}, {y, _} -> x > y end)
    end
  end

  defp passed_threshold?(from, index \\ 0)
  defp passed_threshold?([], _), do: false
  defp passed_threshold?(_, index) when index >= @check_treshold, do: true
  defp passed_threshold?([%{releasing: true} | _], _), do: false
  defp passed_threshold?([_ | rest], index), do: passed_threshold?(rest, index + 1)

  @doc """
  Computes the released pressure based on the steps taken.
  The steps params are a list of tuples, containing the information about the steps taken.
  """
  @spec compute_released(steps :: list(NetworkStep.t()), history :: list(NetworkStep.t()), acc: non_neg_integer()) :: 
    non_neg_integer()
  def compute_released(steps, history, max \\ @max_steps, acc \\ 0)

  def compute_released([], history, _, acc), do: {acc, history}

  def compute_released([%{pressure: 0} | rest], history, max, acc), do: compute_released(rest, history, max, acc)

  def compute_released([%{releasing: false} | rest], history, max, acc), do: compute_released(rest, history, max, acc)
    
  def compute_released([%{step: step, pressure: pressure} | rest], history, max, acc) do
    # Computing the total release pressure by multiplying the pressure of the valve by the difference between the
    # maximum steps possible and the steps taken to get there.
    # Consider that registering the releasing at turn `n` means that it would actually start releasing after that turn.
    # For instance, considering max steps as 3, if the first step as a movement, and the second as releasing the valve,
    # this means that the total release would be equal to max_steps (3) - stet_at_release (2) = 1, times the gas 
    # released per minute.

    compute_released(rest, history, max, (max - step) * pressure + acc)
  end

  def has_been_released?(valve, from) do
    from
    |> Enum.any?(fn 
      %{valve_name: ^valve, releasing: true} -> true
      _ -> false
    end)
  end
end
