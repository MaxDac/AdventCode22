defmodule Computation do
  @moduledoc false

  def get_quickest_way(grid, visited_grid, width, height, start \\ nil) do
    starting_position = {x, y} = 
      case start do
        nil -> Grid.get_starting_position(grid)
        s -> s
      end

    ending_position = Grid.get_ending_position(grid)

    # Initialising the visited_grid
    new_visited_grid =
      visited_grid
      |> Grid.update_grid_element(x, y, %VisibilityMapElement{steps: 0, trail: []})

    get_quickest_way_internal(grid, new_visited_grid, width, height, ending_position, [{0, starting_position}])
  end

  defp get_quickest_way_internal(_, visited_grid, _, _, _, []), do: visited_grid
  defp get_quickest_way_internal(grid, visited_grid, width, height, ending_point, [{_, starting_point = {x, y}} | queue]) do
    %VisibilityMapElement{steps: steps, trail: trail} = 
      Grid.get_grid_element(visited_grid, x, y)

    new_steps = steps + 1
    new_trail = %VisibilityMapElement{
      steps: new_steps, 
      trail: [starting_point | trail]
    }

    {new_queue, new_visited_grid} =
      get_possible_moves(grid, width, height, starting_point)
      |> Enum.reduce({queue, visited_grid}, fn 
        #reached endint point
        ^ending_point, {_, vs} ->
          {pt_x, pt_y} = ending_point
          {[], Grid.update_grid_element(vs, pt_x, pt_y, new_trail)}

        pt = {pt_x, pt_y}, {q, vs} ->
          case Grid.get_grid_element(visited_grid, pt_x, pt_y) do
            # Not yet visited, entering current iteration values
            nil -> {PriorityQueue.add(q, {new_steps, pt}), Grid.update_grid_element(vs, pt_x, pt_y, new_trail)}

            # Steps in the position lower or equal than the one in this iteration, stop here
            %{steps: s1} when s1 <= new_steps -> {q, vs}

            # Steps are actually better, but do not add to queue as already traversed
            _ -> {q, Grid.update_grid_element(vs, pt_x, pt_y, new_trail)}
          end
      end)

    get_quickest_way_internal(grid, new_visited_grid, width, height, ending_point, new_queue)
  end

  defp get_possible_moves(grid, width, height, starting_point = {x, y}) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.filter(&is_move_allowed?(grid, width, height, starting_point, &1))
  end

  defp is_move_allowed?(grid, width, height, starting_point, new_point)
  defp is_move_allowed?(_, _, _, {_, _}, {-1, _}), do: false
  defp is_move_allowed?(_, _, _, {_, _}, {_, -1}), do: false
  defp is_move_allowed?(_, width, _, {_, _}, {new_x, _}) when new_x >= width, do: false
  defp is_move_allowed?(_, _, height, {_, _}, {_, new_y}) when new_y >= height, do: false
  defp is_move_allowed?(grid, width, height, starting_point, new_point) do
    [starting_height, new_height] =
      [starting_point, new_point]
      |> Enum.map(fn {x, y} -> Grid.get_grid_height(grid, width, height, x, y) end)

    new_height <= starting_height + 1
  end
end
