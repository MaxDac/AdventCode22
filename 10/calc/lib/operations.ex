defmodule Operations do
  @moduledoc false

  @type operations() :: :noop | :addx

  @register_initial_value 1
  @initial_clock 20
  @clock_calc_increment 40

  def compute_commands_list(commands, clocks \\ 0, iteration \\ 0, acc \\ [1])

  def compute_commands_list([], _, _, acc), do: 
    acc
    |> Enum.reverse()

  def compute_commands_list([{:noop, _} | rest], clocks, iteration, acc), do:
    compute_commands_list(rest, clocks, iteration + 1, add_clock_value_list(acc, nil))

  def compute_commands_list(list = [{:addx, _} | _], 0, iteration, acc), do:
    compute_commands_list(list, 1, iteration + 1, add_clock_value_list(acc, nil))

  def compute_commands_list([{:addx, number} | rest], 1, iteration, acc), do:
    compute_commands_list(rest, 0, iteration + 1, add_clock_value_list(acc, number))

  defp add_clock_value_list([], nil), do: [@register_initial_value]
  defp add_clock_value_list([], number), do: [number]
  defp add_clock_value_list(list = [last | _], nil), do: [last | list]
  defp add_clock_value_list(list = [last | _], number), do: [last + number | list]

  def compute_signal_strength(value_during_clocks) do
    value_length = length(value_during_clocks)

    Stream.iterate(@initial_clock, &(&1 + @clock_calc_increment))
    |> Enum.take_while(&(&1 < value_length))
    |> Enum.map(&get_at_clock(value_during_clocks, &1))
    |> Enum.sum()
  end

  defp get_at_clock(value_during_clocks, clock), do: 
    Enum.at(value_during_clocks, clock - 1) * clock
end

