defmodule Monkey do
  @moduledoc """
  This is a sort of class that handles a single Monkey. This uses a GenServer, based on an Erlang process,
  to simulate the behaviour of a class by sending messages.

  The first part of the GenServer is the base API wiring, by implementing the `GenServer` behaviour.

  The second part is the API for external use, that implements the "class methods" for a particular server
  PID, that could be thought as an equivalent of the class instance reference.

  The last part is the implementation of the class logic itself.

  The main difference between this implementation and the class is that in the end the "method" equivalents
  are functions, so they need the "class instance", in this case the server instance PIDs, in input as a 
  parameter, while normal class methods already have the class instance available.
  """

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

  # Implementation of the behaviour. This is the basic wiring, where the different functions overrides are
  # used to respond to different parameters. In particular, the parameters over which the pattern matching
  # is applied is the first one, the input itself.
  #
  # Note how there are two different overrides, the `handle_call` is a synchronous method, meaning that it is
  # expected to return a value to the caller, while the `handle_cast` defines asynchronous "fire and forget"
  # calls, something that doesn't exist in normal classes in C#.

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get_items, _from, state = %{items: items}) do
    {:reply, items, state}
  end

  @impl true
  def handle_call(:get_inspections, _from, state = %{checked: checked}) do
    {:reply, checked, state}
  end

  @impl true
  def handle_call(:perform_turn, _from, state = %{
    items: items,
    checked: checked,
  }) do
    number_of_inspections = length(items)

    items
    |> Enum.each(&inspect_item(&1, state))

    {:reply, :ok, %{state | 
      items: [],
      checked: checked + number_of_inspections
    }}
  end

  @impl true
  def handle_cast({:add_monkeys, monkeys}, state) do
    {:noreply, %{state | monkeys: monkeys}}
  end

  @impl true
  def handle_cast({:threw, item}, state = %{
    items: items,
  }) do
    new_items_set = [item | items]
    {:noreply, %{state | items: new_items_set}}
  end

  # This is the "class implementation", the GenServer API callable from the outside.
  # The `start_link` function starts a new process returning its PID, while the others simply send messages to
  # the other processes, using the GenServer API; thus, they are acting as a wrappers for the basic Elixir
  # syntax to handle processes and messages.
  #
  # In the analogy, these would be the class methods, while the messing sending would be the actual call 
  # to a method itself. Note that this happens with independent entities, so the "class" here is in fact
  # a mixture between a C# class and a Task.
  
  def start_link(state) do
    case GenServer.start_link(__MODULE__, state, []) do
      {:ok, pid} ->
        pid

      {:error, {:already_started, pid}} ->
        pid
    end
  end

  def add_monkeys(monkey, monkeys) do
    GenServer.cast(monkey, {:add_monkeys, monkeys})
  end

  def perform_turn(monkey_server) do
    GenServer.call(monkey_server, :perform_turn)
  end

  def throw_item(monkey_server, item) do
    GenServer.cast(monkey_server, {:threw, item})
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
    equivalent_operation = 
      if @relief_level == 1 do operation else fn x -> div(operation.(x), @relief_level) end end

    new_item =
      Item.update_divisibles(item, equivalent_operation)

    throw_to_monkey =
      if Item.test_ok?(new_item, test) do if_true else if_false end

    throw_to(monkeys, throw_to_monkey, new_item)
  end

  defp throw_to(monkeys, monkey_no, item) do
    monkey = Enum.at(monkeys, monkey_no)
    Monkey.throw_item(monkey, item)
  end
end

