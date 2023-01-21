defmodule DrawCrt do
  @moduledoc false

  @screen_width 40

  def draw_crt(register, clock \\ 1, acc \\ [])

  def draw_crt([], _, acc), do: acc |> Enum.reverse()

  def draw_crt([current_register | rest], clock, acc) do
    character = 
      if is_sprite_at_position?(current_register, clock) do
        "#"
      else
        "."
      end

    draw_crt(rest, clock + 1, [character | acc])
  end

  defp is_sprite_at_position?(register, clock) do
    horizontal_position = get_current_horizontal_position(clock)
    (horizontal_position >= register - 1 && horizontal_position <= register + 1)
    |> IO.inspect(label: "sprite position #{register} #{clock} #{horizontal_position}")
  end

  defp get_current_horizontal_position(clock), do: rem(clock - 1, 40)

  def draw(crt) do
    crt
    |> Enum.chunk_every(@screen_width)
    |> Enum.map(&List.to_string(&1))
  end
end
