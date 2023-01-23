defmodule Computation do
  @moduledoc false

  @max_possible 100_000_000

  def get_quickest_way(grid, buffer_grid, width, height) do
    starting_position = Grid.get_starting_position(grid)
    ending_position = Grid.get_ending_position(grid)

    {number_of_steps, path} =
      get_quickest_way_internal(grid, buffer_grid, width, height, starting_position, ending_position)

    {number_of_steps, path |> Enum.reverse()}
  end

  defp get_quickest_way_internal(grid, buffer_grid, grid_width, grid_height, start_position, end_position, steps \\ 0, from \\ [])
  defp get_quickest_way_internal(_, _, _, _, {-1, _}, _, _, from), do: {nil, from}
  defp get_quickest_way_internal(_, _, _, _, {_, -1}, _, _, from), do: {nil, from}
  defp get_quickest_way_internal(_, _, _, _, {x, y}, {x, y}, steps, from), do: {steps, from}
  defp get_quickest_way_internal(grid, buffer_grid, grid_width, grid_height, start_position = {start_x, start_y}, {end_x, end_y}, steps, from) do
    buffer_grid_element = Grid.get_grid_element(buffer_grid, start_x, start_y)
    
    {new_buffer_grid, should_continue?} =
      case buffer_grid_element do
        # No steps were previously registered
        nil -> 
          {
            Grid.update_grid_element(buffer_grid, start_x, start_y, steps),
            true
          }

        # The steps previously taken to arrive here were more than the ones needed here, overwrite
        s when s > steps -> 
          {
            Grid.update_grid_element(buffer_grid, start_x, start_y, steps),
            true
          }

        # Steps taken are inefficient, stopping elaboration
        _ -> 
          {buffer_grid, false}
      end

    if should_continue? do
      {current, up, down, left, right} = {
        Grid.get_grid_height(grid, grid_width, grid_height, start_x, start_y),
        Grid.get_grid_height(grid, grid_width, grid_height, start_x, start_y - 1),
        Grid.get_grid_height(grid, grid_width, grid_height, start_x, start_y + 1),
        Grid.get_grid_height(grid, grid_width, grid_height, start_x - 1, start_y),
        Grid.get_grid_height(grid, grid_width, grid_height, start_x + 1, start_y),
      }

      [
        fn -> 
          if check_way(current, up, from, {start_x, start_y - 1}) do 
            get_quickest_way_internal(grid, new_buffer_grid, grid_width, grid_height, {start_x, start_y - 1}, {end_x, end_y}, steps + 1, [start_position | from]) 
          else 
            {nil, from} 
          end 
        end,
        fn -> 
          if check_way(current, down, from, {start_x, start_y + 1}) do 
            get_quickest_way_internal(grid, new_buffer_grid, grid_width, grid_height, {start_x, start_y + 1}, {end_x, end_y}, steps + 1, [start_position | from]) 
          else 
          {nil, from} 
          end 
        end,
        fn -> 
          if check_way(current, left, from, {start_x - 1, start_y}) do 
            get_quickest_way_internal(grid, new_buffer_grid, grid_width, grid_height, {start_x - 1, start_y}, {end_x, end_y}, steps + 1, [start_position | from]) 
          else 
            {nil, from} 
          end 
        end,
        fn -> 
          if check_way(current, right, from, {start_x + 1, start_y}) do 
            get_quickest_way_internal(grid, new_buffer_grid, grid_width, grid_height, {start_x + 1, start_y}, {end_x, end_y}, steps + 1, [start_position | from]) 
          else 
            {nil, from} 
          end 
        end
      ]
      # |> Enum.map(&Task.async/1)
      # |> Enum.map(&Task.await/1)
      |> Enum.map(fn f -> f.() end)
      |> Enum.map(fn
        {nil, from} -> {@max_possible, from}
        {x, from} -> {x + 1, from}
      end)
      |> min_of(fn {x, _} -> x end)
    else
      {nil, from}
    end
  end

  defp check_way(_, nil, _, _), do: false
  defp check_way(current, next, from, next_position) do
    not(Enum.member?(from, next_position)) && (next == current + 1 || next == current)
  end

  defp min_of(list, f)
  defp min_of([], _), do: nil
  defp min_of([elem], _), do: elem
  defp min_of([first | [second | rest]], f) do
    case {f.(first), f.(second)} do
      {a, b} when a < b -> min_of([first | rest], f)
      _ -> min_of([second | rest], f)
    end
  end
end
