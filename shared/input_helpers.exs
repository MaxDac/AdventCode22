defmodule InputHelpers do
  @moduledoc false

  @spec get_input_rows(input :: binary()) :: list(binary())
  def get_input_rows(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&filter_non_nil_or_empty/1)
  end

  @spec filter_non_nil_or_empty(s :: binary()) :: boolean()
  def filter_non_nil_or_empty(nil), do: false
  def filter_non_nil_or_empty(""), do: false
  def filter_non_nil_or_empty(_), do: true

  @spec parse_int(int :: binary()) :: integer()
  def parse_int(int) do
    case Integer.parse(int) do
      {result, _} -> result
      other -> other
    end
  end
end
