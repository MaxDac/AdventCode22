defmodule Sand do
  @moduledoc false

  @sand_origin_x 500

  def sand_grain(grid, min_x, max_x, max_y, x \\ @sand_origin_x, offset \\ 0, acc \\ 0)
  # def sand_grain(_, min_x, max_x, _, x, _, acc) when x == min_x or x == max_x, do: acc
  def sand_grain(grid, min_x, max_x, max_y, x, offset, acc) do
    # IO.puts("x: #{inspect x}, offset: #{inspect offset}")
    x = x - min_x
    max_x = max_x - min_x

    {_, filled} = split_grid_column_at(grid, max_x, x, offset)
    # |> IO.inspect(label: "split_grid_column_at")

    case {min_x + x, length(filled)} do
      # If the grain of sands reach the hole where the sand is falling, return the accumulated sand
      {@sand_origin_x, ^max_y} -> acc
      # If the length of the filled zone is 0, this means that the grain of sand will fall endlessly into the void
      {_, 0} -> acc
      {_, filled_length} ->
        # Computing new offset, the offset should be the filled length, having that the filled lenght has been already
        # computed considering the previous offset.
        new_offset = filled_length

        case {
          split_grid_column_at(grid, max_x, x - 1, new_offset), 
          split_grid_column_at(grid, max_x, x + 1, new_offset)
        } do
          # left is shorter, left wins
          {{_, left_filled}, _} when length(left_filled) < length(filled) ->
            sand_grain(grid, min_x, max_x + min_x, max_y, x + min_x - 1, new_offset, acc)

          # right is shorter, right wins
          {_, {_, right_filled}} when length(right_filled) < length(filled) ->
            sand_grain(grid, min_x, max_x + min_x, max_y, x + min_x + 1, new_offset, acc)

          # end of conditions, middle wins
          _ ->
            # wait()
            grid = 
              add_sand_to_column(grid, x, max_y - length(filled)) 
              # |> IO.inspect()

            # No offset is necessary, because in this case another grain of sand is considered.
            sand_grain(grid, min_x, max_x + min_x, max_y, @sand_origin_x, 0, acc + 1)
        end
    end 
  end

  defp wait, do: :timer.sleep(100)

  @doc """
  Splits the column in the grid identified by the `at` parameter. 
  The `offset` parameter is used to analyse the column until a certain height from the bottom, 
  meaning that if the grid is 10 lines long and the offset is 3, the resulting line in which 
  the split will happen will be 3 long, from the bottom:

  [".", ".", ".", ".", ".", ".", ".", "#"] -> offset 3 -> [".", ".", "#"]
  """
  @spec split_grid_column_at(Matrix.t(), non_neg_integer, integer(), non_neg_integer()) :: 
    {list(binary()), list(binary())}
  def split_grid_column_at(grid, max_x, at, offset \\ 0)
  def split_grid_column_at(_, _, at, _) when at < 0, do: nil
  def split_grid_column_at(_, max_x, at, _) when at >= max_x, do: nil
  def split_grid_column_at(grid, _, at, 0) do
    grid
    |> elem(at)
    |> Enum.split_while(&(&1 == "."))
  end
  def split_grid_column_at(grid, _, at, offset) do
    line = 
      grid
      |> elem(at)

    line_length = length(line)

    line
    |> Enum.drop(line_length - offset)
    |> Enum.split_while(&(&1 == "."))
  end

  @doc """
  Adds a sand grain to the current line. The grain of sand will be put at the given position, having that the
  grain of sand can fall from a nearby column.
  """
  @spec add_sand_to_column(Matrix.t(), non_neg_integer(), non_neg_integer()) :: Matrix.t()
  def add_sand_to_column(grid, x, position) do
    grid
    |> Matrix.update_grid_at(x, new_line_with_sand(position))
  end

  defp new_line_with_sand(position) do
    fn line ->
      {free, filled} = Enum.split(line, position)
      take_until_last(free) ++ ["o" | filled]
    end
  end

  defp take_until_last(list, acc \\ [])
  defp take_until_last([], acc), do: Enum.reverse(acc)
  defp take_until_last([_], acc), do: Enum.reverse(acc)
  defp take_until_last([item | rest], acc), do: take_until_last(rest, [item | acc])
end

