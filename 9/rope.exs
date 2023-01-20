defmodule Rope do
  @moduledoc false

  use GenServer

  @impl true
  def init(rope_length) do
    {:ok, 
      1..rope_length
      |> Enum.map(fn _ -> {0, 0} end)
    }
  end

    @impl true
  def handle_call({:new_position, direction}, _from, rope) do
    new_rope = compute_new_rope(rope, direction)
    new_tail_position = last(new_rope)

    {:reply, new_tail_position, new_rope}
  end
  
  defp last([last]), do: last
  defp last([_ | rest]), do: last(rest)

  def start_link(rope_length \\ 10) do
    case GenServer.start_link(__MODULE__, rope_length, []) do
      {:ok, server} -> server
    end
  end

  def move_rope(server, direction) do
    GenServer.call(server, {:new_position, direction})
  end

  defp compute_new_rope([head | rest], direction) do
    new_head = compute_new_position(head, direction)
    compute_rope_tail(rest, new_head, []) 
  end

  defp compute_new_position({x, y}, :up), do: {x, y + 1}
  defp compute_new_position({x, y}, :down), do: {x, y - 1}
  defp compute_new_position({x, y}, :left), do: {x - 1, y}
  defp compute_new_position({x, y}, :right), do: {x + 1, y}

  defp compute_rope_tail([], new_head_position, acc), do: 
    [new_head_position | acc] 
    |> Enum.reverse()
    
  defp compute_rope_tail([knot | rest], new_head_position, acc) do
    new_knot = get_new_knot_position(knot, new_head_position)
    compute_rope_tail(rest, new_knot, [new_head_position | acc])
  end

  defp get_new_knot_position(previous_knot_position, head_position) do
    if update_position?(previous_knot_position, head_position) do
      compute_new_tail_position(head_position, previous_knot_position)
    else
      previous_knot_position
    end
  end

  defp update_position?({x1, y1}, {x2, y2}) do
    {diffx, diffy} =
      {abs(x1 - x2), abs(y1 - y2)}

    is_less_or_equal_one? = ((diffx + diffy) <= 1)
    is_diagonal? = (diffx == 1 && diffy == 1)
 
    not(is_less_or_equal_one? || is_diagonal?)
  end

  defp compute_new_tail_position({hx, hy}, {tx, ty}) do
    case {(hx - tx), (hy - ty)} do
      # Left move
      {-2, 0} -> {tx - 1, ty}

      # Right move
      {2, 0} -> {tx + 1, ty}

      # Bottom move
      {0, -2} -> {tx, ty - 1}

      # Top move
      {0, 2} -> {tx, ty + 1}

      # Top right
      {a, b} when a > 0 and b > 0 -> {tx + 1, ty + 1}

      # Top left
      {a, b} when a < 0 and b > 0 -> {tx - 1, ty + 1}

      # Bottom left
      {a, b} when a < 0 and b < 0 -> {tx - 1, ty - 1}

      # Bottom right
      {a, b} when a > 0 and b < 0 -> {tx + 1, ty - 1}
    end
  end
end
