defmodule Command do
  @command_scrubber [IO.ANSI.Cursor.clear_line, IO.ANSI.Cursor.cursor_up, IO.ANSI.Cursor.clear_line, IO.ANSI.Cursor.cursor_up, IO.ANSI.Cursor.clear_line]

  def interpret([:speed, value]), do: [@command_scrubber, Calendar.set_speed(value)]
  def interpret(:speed), do: [@command_scrubber, Calendar.get_speed]

  def interpret(:map),   do: [@command_scrubber, Landscape.display]
  def interpret(:clear), do: IO.ANSI.Cursor.clear
  def interpret(:boom),  do: Calendar.boom
  def interpret(:time),  do: [@command_scrubber, Calendar.glance]
  def interpret(:quit),  do: "Goodbye."
  def interpret(:rain),  do: [@command_scrubber, Landscape.rain]
  # def interpret(:help),  do: [@command_scrubber, Command.help]
  # def interpret(:menu),  do: [@command_scrubber, Command.menu]

  # def interpret(["shutdown"]), do: "Server shutting down..."

  def interpret(command), do: [@command_scrubber, 'You said "', IO.ANSI.green, command, IO.ANSI.reset, "\", but I don't know what that means."]
end
