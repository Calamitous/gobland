defmodule Landscape do
  use GenServer

  def start_link, do: GenServer.start_link(__MODULE__, nil, name: :landscape)
  def start, do: GenServer.start(__MODULE__, nil, name: :landscape)
  def init(_), do: {:ok, Landscape.build_map(50, 15)}

  def advance, do: GenServer.cast(:landscape, :advance)
  def display, do: GenServer.call(:landscape, :display)
  def rain do
    GenServer.cast(:landscape, :rain)
    "Rain falls"
  end

  def handle_cast(:advance, state),  do: {:noreply, Landscape.update(state)}
  def handle_cast(:rain, state),     do: {:noreply, Landscape.Water.add(state)}
  def handle_call(:display, _, map), do: {:reply, Landscape.Display.print_map(map), map}

  def update(world), do: world |> Landscape.Water.flow

  def build_map(w, h),                               do: build_map({w, h, []})
  defp build_map({w, h, m}) when length(m) == w * h, do: Landscape.Water.add({w, h, m})
  defp build_map({w, h, m}) when length(m) < w * h,  do: build_map({w, h, m ++ elevation()})

  defp elevation, do: [{:random.uniform(3) - 1, false, :random.uniform(3) - 1}]
end
