defmodule Gobland do
  use Supervisor
  def start(:normal, _) do
    Calendar.start
    Landscape.start
    Connections.start
    Telnet.start(6000)
    # Supervisor.start_link __MODULE__, nil
    supervise([worker(Calendar, [])], strategy: :one_for_one)
    supervise([worker(Landscape, [])], strategy: :one_for_one)
    supervise([worker(Connections, [])], strategy: :one_for_one)
    supervise([worker(Telnet, [])], strategy: :one_for_one)
    Supervisor.start_link [], strategy: :one_for_one
  end
end
