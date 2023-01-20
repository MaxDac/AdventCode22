defmodule StateCollector do
  use GenServer

  @impl true
  def init(:ok) do
    {:ok, []}
  end

  @impl true
  def handle_call(:get, _from, positions) do
    {:reply, positions, positions}
  end
  
  @impl true
  def handle_cast({:put, position}, positions) do
    {:noreply, [position | positions]}
  end

  # Client API
  def start_link(opts \\ []) do
    case GenServer.start_link(__MODULE__, :ok, opts) do
      {:ok, server} -> server
    end
  end

  def put(server, position) do
    case GenServer.cast(server, {:put, position}) do
      :ok -> server
      other -> other
    end
  end
  
  def get(server) do
    GenServer.call(server, :get)
  end
end
 
