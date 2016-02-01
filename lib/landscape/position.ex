defmodule Landscape.Position do
  defmacro top(w, _, ele), do: quote do: unquote(w) > unquote(ele)
  defmacro bot(w, h, ele), do: quote do: unquote(h) <= (div(unquote(ele), unquote(w)) + 1)
  defmacro bol(w, _, ele), do: quote do: rem(unquote(ele), unquote(w)) == 0
  defmacro eol(w, _, ele), do: quote do: rem(unquote(ele) + 1, unquote(w)) == 0

  def elem_to_xy(w, ele),   do: {div(ele, w), rem(ele, w)}
  def xy_to_elem(w, {x, y}), do: (w * y) + x

  def neighbor(w, _, ele, :n)  when not top(w, h, ele),                         do: ele - w
  def neighbor(w, h, ele, :e)  when not eol(w, h, ele),                         do: ele + 1
  def neighbor(w, h, ele, :s)  when not bot(w, h, ele),                         do: ele + w
  def neighbor(w, h, ele, :w)  when not bol(w, h, ele),                         do: ele - 1
  def neighbor(w, h, ele, :ne) when not top(w, h, ele) and not eol(w, h, ele), do: (ele - w) + 1
  def neighbor(w, h, ele, :se) when not bot(w, h, ele) and not eol(w, h, ele), do: ele + w + 1
  def neighbor(w, h, ele, :sw) when not bot(w, h, ele) and not bol(w, h, ele), do: (ele + w) - 1
  def neighbor(w, h, ele, :nw) when not top(w, h, ele) and not bol(w, h, ele), do: ele - 1 - w
  def neighbor(_, _, ele, _), do: ele

  def neighbors(w, h, ele),                               do: neighbors(w, h, ele, [:n, :ne, :e, :se, :s, :sw, :w, :nw], [])
  def neighbors(w, h, ele, [direction | tail], elements), do: neighbors(w, h, ele, tail, [neighbor(w, h, ele, direction)| elements])
  def neighbors(_, _, ele, [], elements),                 do: Enum.uniq(elements) -- [ele]
end
