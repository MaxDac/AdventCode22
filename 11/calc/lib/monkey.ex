defmodule Monkey do
  @moduledoc false

  @relief_level 1

  use GenServer

  defmodule MonkeyState do
    defstruct monkeys: [],
              items: [],
              checked: 0,
              operation: nil,
              test: nil,
              if_false: 0,
              if_true: 0
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:add_monkeys, monkeys}, _from, state) do
    {:reply, :ok, %{state | monkeys: monkeys}}
  end

  @impl true
  def handle_call(:perform_turn, _from, state = %{
    items: items,
    checked: checked,
  }) do
    number_of_inspections = length(items)

    items
    |> Enum.each(&inspect_item(&1, state))

    {:reply, [], %{state | 
      items: [],
      checked: checked + number_of_inspections
    }}
  end

  @impl true
  def handle_call({:threw, item}, _from, state = %{
    items: items,
  }) do
    new_items_set = [item | items]
    {:reply, new_items_set, %{state | items: new_items_set}}
  end
  
  @impl true
  def handle_call(:get_items, _from, state = %{items: items}) do
    {:reply, items, state}
  end

  @impl true
  def handle_call(:get_inspections, _from, state = %{checked: checked}) do
    {:reply, checked, state}
  end

  def start_link(state) do
    case GenServer.start_link(__MODULE__, state, []) do
      {:ok, pid} ->
        pid

      {:error, {:already_started, pid}} ->
        pid
    end
  end

  def add_monkeys(monkey, monkeys) do
    GenServer.call(monkey, {:add_monkeys, monkeys})
  end

  def perform_turn(monkey_server) do
    GenServer.call(monkey_server, :perform_turn)
  end

  def throw_item(monkey_server, item) do
    GenServer.call(monkey_server, {:threw, item})
  end

  def get_items(monkey_server) do
    GenServer.call(monkey_server, :get_items)
  end

  def get_inspections(monkey_server) do
    GenServer.call(monkey_server, :get_inspections)
  end

  # Implementation

  defp inspect_item(item, %{
    monkeys: monkeys,
    operation: operation,
    test: test,
    if_false: if_false,
    if_true: if_true
  }) do
    new_worry_level = div(operation.(item), @relief_level)
    throw_to(monkeys, if test.(new_worry_level) do if_true else if_false end, new_worry_level)
  end

  defp throw_to(monkeys, monkey_no, item) do
    monkey = Enum.at(monkeys, monkey_no)
    Monkey.throw_item(monkey, item)
  end
end

