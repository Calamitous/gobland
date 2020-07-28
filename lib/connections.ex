defmodule Connections do
  use GenServer

  # def start_link, do: GenServer.start_link(__MODULE__, nil, name: :calendar)
  def start, do: GenServer.start(__MODULE__, nil, name: :connections)

  def init(_) do
    # :timer.send_interval(1000, :advance)
    {:ok, []}
  end

  def handle_cast({:add, conn}, connections),    do: {:noreply, connections ++ [conn]}
  def handle_cast({:remove, conn}, connections), do: {:noreply, List.delete(connections, conn)}
  def handle_info(:list, connections),           do: {:noreply, IO.inspect(connections)}
end
