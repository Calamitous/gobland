defmodule Landscape.Water do
  # Water doesn't flow in the winter!
  # def flow({w, h, m}) when Calendar.season == :winter, do: {w, h, m}

  # Generation
  def add({w, h, m}) do
    add({w, h, m}, :random.uniform(w * h))
  end

  def add({w, h, m}, ele) do
    {elev, _, ground_cover} = hd(Enum.slice(m, ele..ele))
    {w, h, Enum.slice(m, 0..ele-1) ++ [{elev, true, ground_cover}] ++ Enum.slice(m, ele+1..length(m))}
  end

  def flow({w, h, m}) do
    {w, h, Enum.map(Enum.with_index(m), fn({{elev, has_water, ground_cover}, i}) ->
      {elev, has_water || should_have_water({w, h, m}, i), ground_cover}
    end)}
  end

  defp should_have_water({w, h, m}, ele) do
    m = List.to_tuple(m)
    Landscape.Position.neighbors(w, h, ele)
    |> Enum.map(fn(e) -> elem(m, e) end)
    |> Enum.filter(fn({lev, _, _}) -> lev >= get_elevation(m, ele) end)
    |> Enum.map(fn(c) -> elem(c, 1) end)
    |> Enum.reduce(false, fn(c, acc) -> acc || c end)
  end

  defp get_elevation(m, ele), do: elem(elem(m, ele), 0)
end
