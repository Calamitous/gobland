defmodule Display do
  def show(text), do: [text, ?\n, prompt()]
  def refresh(text), do: show([IO.ANSI.Cursor.clear, text])
  defp prompt(), do: ' > '
end

