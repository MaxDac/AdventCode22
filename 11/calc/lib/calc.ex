defmodule Calc do
  @moduledoc false

  @number_or_rounds 10_000

  def compute() do
    monkeys = build_monkeys()

    for _ <- 1..@number_or_rounds do
      monkeys
      |> Enum.each(&Monkey.perform_turn/1)
    end

    monkeys
    |> Enum.map(&Monkey.get_inspections/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(2)
    |> Enum.product()
  end

  defp build_test_monkeys() do
    monkeys = 
      [
        Monkey.start_link(%Monkey.MonkeyState{
          items: [79, 98] |> Enum.map(&Item.new/1),
          operation: fn x -> x * 19 end,
          test: 23,
          if_true: 2,
          if_false: 3
        }),
        Monkey.start_link(%Monkey.MonkeyState{
          items: [54, 65, 75, 74] |> Enum.map(&Item.new/1),
          operation: fn x -> x + 6 end,
          test: 19,
          if_true: 2,
          if_false: 0
        }),
        Monkey.start_link(%Monkey.MonkeyState{
          items: [79, 60, 97] |> Enum.map(&Item.new/1),
          operation: fn x -> x * x end,
          test: 13,
          if_true: 1,
          if_false: 3
        }),
        Monkey.start_link(%Monkey.MonkeyState{
          items: [74] |> Enum.map(&Item.new/1),
          operation: fn x -> x + 3 end,
          test: 17,
          if_true: 0,
          if_false: 1
        }),
      ]

    monkeys
    |> Enum.each(fn monkey ->
      Monkey.add_monkeys(monkey, monkeys)
    end)

    monkeys
  end

  defp build_monkeys() do
    monkeys = 
      [
        # Monkey 0
        Monkey.start_link(%Monkey.MonkeyState{
          items: [73, 77] |> Enum.map(&Item.new/1),
          operation: fn x -> x * 5 end,
          test: 11,
          if_true: 6,
          if_false: 5
        }),

        # Monkey 1
        Monkey.start_link(%Monkey.MonkeyState{
          items: [57, 88, 80] |> Enum.map(&Item.new/1),
          operation: fn x -> x + 5 end,
          test: 19,
          if_true: 6,
          if_false: 0
        }),

        # Monkey 2
        Monkey.start_link(%Monkey.MonkeyState{
          items: [61, 81, 84, 69, 77, 88] |> Enum.map(&Item.new/1),
          operation: fn x -> x * 19 end,
          test: 5,
          if_true: 3,
          if_false: 1
        }),

        # Monkey 3
        Monkey.start_link(%Monkey.MonkeyState{
          items: [78, 89, 71, 60, 81, 84, 87, 75] |> Enum.map(&Item.new/1),
          operation: fn x -> x + 7 end,
          test: 3,
          if_true: 1,
          if_false: 0
        }),

        # Monkey 4
        Monkey.start_link(%Monkey.MonkeyState{
          items: [60, 76, 90, 63, 86, 87, 89] |> Enum.map(&Item.new/1),
          operation: fn x -> x + 2 end,
          test: 13,
          if_true: 2,
          if_false: 7
        }),

        # Monkey 5
        Monkey.start_link(%Monkey.MonkeyState{
          items: [88] |> Enum.map(&Item.new/1),
          operation: fn x -> x + 1 end,
          test: 17,
          if_true: 4,
          if_false: 7
        }),

        # Monkey 6
        Monkey.start_link(%Monkey.MonkeyState{
          items: [84, 98, 78, 85] |> Enum.map(&Item.new/1),
          operation: fn x -> x * x end,
          test: 7,
          if_true: 5,
          if_false: 4
        }),

        # Monkey 7
        Monkey.start_link(%Monkey.MonkeyState{
          items: [98, 89, 78, 73, 71] |> Enum.map(&Item.new/1),
          operation: fn x -> x + 4 end,
          test: 2,
          if_true: 3,
          if_false: 2
        }),
      ]

    monkeys
    |> Enum.each(fn monkey ->
      Monkey.add_monkeys(monkey, monkeys)
    end)

    monkeys
  end
end
