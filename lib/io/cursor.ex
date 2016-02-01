defmodule IO.ANSI.Cursor do
  import IO.ANSI.Sequence

  @doc "Clears screen"
  defsequence :clear, "2", "J"

  @doc "Clears line"
  defsequence :clear_line, "2", "K"

  @doc "Reports the cursor position"
  defsequence :cursor_position, 6, "n"

  @doc "Saves cursor position"
  defsequence :save_cursor_position, "s"

  @doc "Restores cursor position"
  defsequence :restore_cursor_position, "u"

  @doc "Hides cursor"
  defsequence :hide_cursor, "\?25", "l"

  @doc "Shows cursor"
  defsequence :show_cursor, "\?25", "h"

  @doc "Clears from the cursor to the bottom of screen"
  defsequence :clear_from_cursor_down, "0", "J"

  @doc "Clears from the cursor to the top of screen"
  defsequence :clear_from_cursor_up, "1", "J"

  @doc "Clears from the cursor to the end of the line"
  defsequence :clear_from_cursor_forward, "2", "K"

  @doc "Clears from the cursor to the beginning of the line"
  defsequence :clear_from_cursor_back, "1", "K"

  @doc "Move cursor up the specified number of lines"
  @spec cursor_up(integer) :: String.t
  def cursor_up(lines \\ 1) when lines >= 0, do: "\e[#{lines}A"

  @doc "Move cursor down the specified number of lines"
  @spec cursor_down(integer) :: String.t
  def cursor_down(lines \\ 1) when lines >= 0, do: "\e[#{lines}B"

  @doc "Move cursor right/forward the specified number of columns"
  @spec cursor_forward(integer) :: String.t
  def cursor_forward(columns \\ 1) when columns >= 0, do: "\e[#{columns}C"

  @doc "Move cursor left/back the specified number of columns"
  @spec cursor_back(integer) :: String.t
  def cursor_back(columns \\ 1) when columns >= 0, do: "\e[#{columns}D"

  @doc "Move cursor to the beginning of line the specified number of lines down"
  @spec cursor_next_line(integer) :: String.t
  def cursor_next_line(lines \\ 1) when lines >= 0, do: "\e[#{lines}E"

  @doc "Move cursor to the beginning of line the specified number of lines up"
  @spec cursor_previous_line(integer) :: String.t
  def cursor_previous_line(lines \\ 1) when lines >= 0, do: "\e[#{lines}F"

  @doc "Move cursor to the specified column"
  @spec cursor_to_column(integer) :: String.t
  def cursor_to_column(column) when column >= 1, do: "\e[#{column}G"

  @doc "Move cursor to the specified line"
  @spec cursor_to_line(integer) :: String.t
  def cursor_to_line(line) when line >= 1, do: "\e[#{line}H"

  @doc "Scrolls the screen up the specified number of lines"
  @spec scroll_up(integer) :: String.t
  def scroll_up(lines) when lines >= 0, do: "\e[#{lines}S"

  @doc "Scrolls the screen down the specified number of lines"
  @spec scroll_down(integer) :: String.t
  def scroll_down(lines) when lines >= 0, do: "\e[#{lines}T"

  @doc ~S"""
  Move cursor to the specified column and line.

  These values are 1-based, so calling this with column = 1 and row = 1 will
  move the cursor to the top-left of the screen.
  """
  @spec cursor_to(integer, integer) :: String.t
  def cursor_to(column, line) when column >= 1 and line >= 1 do
    "\e[#{column};#{line}f"
  end

end

