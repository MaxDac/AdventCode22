defmodule Input do
  @moduledoc false

  def get_input(input_file) do
    input_file
    |> get_complete_file_path()
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(&is_not_null_nor_empty/1)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_line/1)
  end

  defp get_complete_file_path(filename) do
    "#{Path.dirname(__DIR__)}/lib/#{filename}"
  end

  defp parse_line(line) do
    line
    |> String.split("")
    |> Enum.filter(&is_not_null_nor_empty/1)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&letter_to_char/1)
  end

  defp is_not_null_nor_empty(nil), do: false
  defp is_not_null_nor_empty(""), do: false
  defp is_not_null_nor_empty(_), do: true

  defp letter_to_char(<<letter::utf8>>), do: letter
end
