defmodule Calc do
  @moduledoc false

  @relief_coefficient 1
  @number_of_rounds 10_000

  defmodule Monkey do
    defstruct items: [],
              operation: nil,
              test: 0,
              if_true: 0,
              if_false: 0,
              number_of_checks: 0
  end

  def compute() do
    data = test_data()
    monkey_number = tuple_size(data)

    state_after_reduce =
      1..@number_of_rounds
      |> Enum.reduce(data, fn _, state ->
        1..monkey_number
        |> Enum.reduce(state, fn monkey_number, s ->
          {items, monkey, s} = begin_inspection(s, monkey_number - 1)

          s
          |> inspect_items(monkey, items)
        end)
      end)

    state_after_reduce
    |> Tuple.to_list()
    |> Enum.map(&(&1.number_of_checks))
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(2)
    |> Enum.product()
  end

  def begin_inspection(state, from) do
    monkey = elem(state, from)
    items_length = monkey.items |> length()
    new_monkey = %Monkey{monkey | 
      number_of_checks: monkey.number_of_checks + items_length,
      items: []
    }

    {monkey.items, new_monkey, update_tuple(state, new_monkey, from)}
  end

  def inspect_items(state, _monkey, []), do: state

  def inspect_items(state, monkey = %{
    operation: operation,
    test: test,
    if_true: if_true,
    if_false: if_false
  }, [item | rest]) do
    new_item = operation.(item)
    new_item = div(new_item, @relief_coefficient)

    new_state = 
      if rem(new_item, test) == 0 do
        move_item(state, new_item, if_true)
      else
        move_item(state, new_item, if_false)
      end

    inspect_items(new_state, monkey, rest)
  end

  def move_item(state, item, to) do
    monkey = elem(state, to)
    new_monkey = %Monkey{monkey | items: [item | monkey.items]}

    update_tuple(state, new_monkey, to)
  end

  def update_tuple(tuple, item, at) do
    tuple
    |> Tuple.delete_at(at)
    |> Tuple.insert_at(at, item)
  end

  def test_data do
    {
      %Monkey{
        items: [79, 98],
        operation: fn x -> x * 19 end,
        test: 23,
        if_true: 2,
        if_false: 3
      },
      %Monkey{
        items: [54, 65, 75, 74],
        operation: fn x -> x + 6 end,
        test: 19,
        if_true: 2,
        if_false: 0
      },
      %Monkey{
        items: [79, 60, 97],
        operation: fn x -> x * x end,
        test: 13,
        if_true: 1,
        if_false: 3
      },
      %Monkey{
        items: [74],
        operation: fn x -> x + 3 end,
        test: 17,
        if_true: 0,
        if_false: 1
      },
    }
  end

  def data do
    {
      # Monkey 0
      %Monkey{
        items: [73, 77],
        operation: fn x -> x * 5 end,
        test: 11,
        if_true: 6,
        if_false: 5
      },

      # Monkey 1
      %Monkey{
        items: [57, 88, 80],
        operation: fn x -> x + 5 end,
        test: 19,
        if_true: 6,
        if_false: 0
      },

      # Monkey 2
      %Monkey{
        items: [61, 81, 84, 69, 77, 88],
        operation: fn x -> x * 19 end,
        test: 5,
        if_true: 3,
        if_false: 1
      },

      # Monkey 3
      %Monkey{
        items: [78, 89, 71, 60, 81, 84, 87, 75],
        operation: fn x -> x + 7 end,
        test: 3,
        if_true: 1,
        if_false: 0
      },

      # Monkey 4
      %Monkey{
        items: [60, 76, 90, 63, 86, 87, 89],
        operation: fn x -> x + 2 end,
        test: 13,
        if_true: 2,
        if_false: 7
      },

      # Monkey 5
      %Monkey{
        items: [88],
        operation: fn x -> x + 1 end,
        test: 17,
        if_true: 4,
        if_false: 7
      },

      # Monkey 6
      %Monkey{
        items: [84, 98, 78, 85],
        operation: fn x -> x * x end,
        test: 7,
        if_true: 5,
        if_false: 4
      },

      # Monkey 7
      %Monkey{
        items: [98, 89, 78, 73, 71],
        operation: fn x -> x + 4 end,
        test: 2,
        if_true: 3,
        if_false: 2
      },
    }
  end
  
end
