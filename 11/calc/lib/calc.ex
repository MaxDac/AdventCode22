defmodule Calc do
  @moduledoc false

  @number_or_rounds 1000

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
          items: [79, 98],
          operation: fn x -> x * 19 end,
          test: fn x -> rem(x, 23) == 0 end,
          if_true: 2,
          if_false: 3
        }),
        Monkey.start_link(%Monkey.MonkeyState{
          items: [54, 65, 75, 74],
          operation: fn x -> x + 6 end,
          test: fn x -> rem(x, 19) == 0 end,
          if_true: 2,
          if_false: 0
        }),
        Monkey.start_link(%Monkey.MonkeyState{
          items: [79, 60, 97],
          operation: fn x -> x * x end,
          test: fn x -> rem(x, 13) == 0 end,
          if_true: 1,
          if_false: 3
        }),
        Monkey.start_link(%Monkey.MonkeyState{
          items: [74],
          operation: fn x -> x + 3 end,
          test: fn x -> rem(x, 17) == 0 end,
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
          items: [73, 77],
          operation: fn x -> x * 5 end,
          test: fn x -> rem(x, 11) == 0 end,
          if_true: 6,
          if_false: 5
        }),

        # Monkey 1
        Monkey.start_link(%Monkey.MonkeyState{
          items: [57, 88, 80],
          operation: fn x -> x + 5 end,
          test: fn x -> rem(x, 19) == 0 end,
          if_true: 6,
          if_false: 0
        }),

        # Monkey 2
        Monkey.start_link(%Monkey.MonkeyState{
          items: [61, 81, 84, 69, 77, 88],
          operation: fn x -> x * 19 end,
          test: fn x -> rem(x, 5) == 0 end,
          if_true: 3,
          if_false: 1
        }),

        # Monkey 3
        Monkey.start_link(%Monkey.MonkeyState{
          items: [78, 89, 71, 60, 81, 84, 87, 75],
          operation: fn x -> x + 7 end,
          test: fn x -> rem(x, 3) == 0 end,
          if_true: 1,
          if_false: 0
        }),

        # Monkey 4
        Monkey.start_link(%Monkey.MonkeyState{
          items: [60, 76, 90, 63, 86, 87, 89],
          operation: fn x -> x + 2 end,
          test: fn x -> rem(x, 13) == 0 end,
          if_true: 2,
          if_false: 7
        }),

        # Monkey 5
        Monkey.start_link(%Monkey.MonkeyState{
          items: [88],
          operation: fn x -> x + 1 end,
          test: fn x -> rem(x, 17) == 0 end,
          if_true: 4,
          if_false: 7
        }),

        # Monkey 6
        Monkey.start_link(%Monkey.MonkeyState{
          items: [84, 98, 78, 85],
          operation: fn x -> x * x end,
          test: fn x -> rem(x, 7) == 0 end,
          if_true: 5,
          if_false: 4
        }),

        # Monkey 7
        Monkey.start_link(%Monkey.MonkeyState{
          items: [98, 89, 78, 73, 71],
          operation: fn x -> x + 4 end,
          test: fn x -> rem(x, 2) == 0 end,
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
