defmodule Landscape do
  use GenServer

  def start_link, do: GenServer.start_link(__MODULE__, nil, name: :landscape)
  def start, do: GenServer.start(__MODULE__, nil, name: :landscape)
  def init(_), do: {:ok, Landscape.build_map(50, 15)}

  # def handle_info(:advance, state),   do: {:noreply, advance(state)}

  def handle_call(:display, _, map), do: {:reply, Landscape.Display.print_map(map), map}

  def display, do: GenServer.call(:landscape, :display)

  def make() do
    Landscape.build_map(50, 15)
    |> Landscape.add_water
    |> Landscape.Display.print_map
    |> Landscape.advance
  end

  def add_calendar(map), do: {map, {1, :spring, 1, 8, 0, :pause}}

  def update(world), do: world |> Landscape.Water.flow

  # Generation
  def add_water({w, h, m}), do: add_water({w, h, m}, :random.uniform(w * h))
  def add_water({w, h, m}, ele) do
    {elev, _, grass} = hd(Enum.slice(m, ele..ele))
    {w, h, Enum.slice(m, 0..ele-1) ++ [{elev, true, grass}] ++ Enum.slice(m, ele+1..length(m))}
  end

  def build_map(w, h),                               do: build_map({w, h, []})
  defp build_map({w, h, m}) when length(m) == w * h, do: {w, h, m}
  defp build_map({w, h, m}) when length(m) < w * h,  do: build_map({w, h, m ++ elevation()})

  defp elevation, do: [{:random.uniform(3) - 1, false, :random.uniform(3) - 1}]
end
