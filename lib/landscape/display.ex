defmodule Landscape.Display do
  require Landscape.Position

  @reset  IO.ANSI.reset

  def bol,             do: IO.ANSI.Cursor.cursor_to_column(1)

  def lava(_),         do: "#{IO.ANSI.red_background}#{IO.ANSI.black}"
  def hole(_),         do: "#{IO.ANSI.black_background}#{IO.ANSI.white}"

  def water(:winter),  do: "#{IO.ANSI.cyan_background}#{IO.ANSI.black}"
  def water(_),        do: "#{IO.ANSI.color_background(1, 1, 5)}#{IO.ANSI.black}"

  def dirt(:winter),   do: "#{IO.ANSI.white_background}#{IO.ANSI.black}"
  def dirt(_),         do: "#{IO.ANSI.color_background(1, 1, 0)}"

  def grass(:fall),    do: [IO.ANSI.yellow_background, IO.ANSI.black]
  def grass(:winter),  do: "#{IO.ANSI.white_background}#{IO.ANSI.black}"
  def grass(_),        do: "#{IO.ANSI.green_background}#{IO.ANSI.black}"

  def flower(:winter), do: "#{IO.ANSI.white_background}#{IO.ANSI.black}#{IO.ANSI.faint}"
  def flower(_),       do: "#{IO.ANSI.green_background}#{IO.ANSI.yellow}"

  def topleft(h),      do: IO.ANSI.Cursor.cursor_to(1, h)

  def assemble_map({w, h, m}) do
    m
    |> Enum.with_index
    |> Enum.map(fn({c, i}) -> cell_print(c, Landscape.Position.eol(w, h, i)) end)
  end

  def print_map({w, h, m}), do: [IO.ANSI.Cursor.cursor_up(h) | assemble_map({w, h, m})]

  defp cell_print({c, false, 0}, is_eol), do: smart_put("#{dirt(Calendar.season)}#{c}#{@reset}", is_eol)
  defp cell_print({c, false, 1}, is_eol), do: smart_put("#{grass(Calendar.season)}#{c}#{@reset}", is_eol)
  defp cell_print({c, false, 2}, is_eol), do: smart_put("#{flower(Calendar.season)}#{c}#{@reset}", is_eol)
  defp cell_print({c, true, _},  is_eol), do: smart_put("#{water(Calendar.season)}#{c}#{@reset}", is_eol)

  defp smart_put(str, true), do: [str, IO.ANSI.Cursor.cursor_next_line]
  defp smart_put(str, _),    do: str
end
