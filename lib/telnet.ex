defmodule Telnet do
  require Logger

  def start(port) do
    Logger.info ['* Starting on port ', Integer.to_string(port), '...']
    tcp_options = [:binary, {:packet, 0}, {:active, false}]
     check_startup :gen_tcp.listen(port, tcp_options)
  end

  def check_startup({:ok, socket}), do: listen(socket)
  def check_startup({:error, :eaddrinuse}), do: Logger.error("Requested address is already in use")

  defp conn_id(conn), do: conn |> Port.info |> Keyword.get(:id, 0) |> Integer.to_string

  def push_update(conns) do
    map = make_response(:map)
    Enum.each conns, fn conn -> :gen_tcp.send(conn, map) end
  end

  defp listen(socket) do
    {:ok, conn} = :gen_tcp.accept(socket)
    Logger.info ["Opening socket connection #", conn_id(conn)]
    :gen_tcp.send(conn, Display.refresh('Welcome to the server!'))
    spawn(fn -> recv(conn) end)
    listen(socket) # For now, stop after 1 connection closes
  end

  defp handle_message(conn, data) do
    command = make_command(data)
    Logger.info ["Got '", data, ?']
    response = make_response(command)
    :gen_tcp.send(conn, make_response(command))
    loop(conn, command)
  end

  defp make_command(data) do
    data
    |> to_string
    |> String.split
    |> Normalizer.normalize
  end

  defp make_response(command) do
    command
    |> Command.interpret
    |> Display.show
  end

  defp loop(conn, :shutdown) do
    Logger.info ["Received shutdown command from #", conn_id(conn)]
    loop(conn, "quit")
  end

  defp loop(conn, :quit) do
    Logger.info ["Closing socket connection #", conn_id(conn)]
    :gen_tcp.close(conn)
  end

  defp loop(conn, _), do: recv(conn)

  defp recv(conn) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, data} -> handle_message(conn, String.rstrip(data))
      {:error, :closed} -> :ok
    end
  end
end
