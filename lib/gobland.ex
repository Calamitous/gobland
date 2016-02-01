defmodule Gobland do
  use Supervisor
  def start(:normal, _) do
    c = Calendar.start
    l = Landscape.start
    t = Telnet.start(6000)
    # Supervisor.start_link __MODULE__, nil
    supervise([worker(Calendar, [])], strategy: :one_for_one)
    supervise([worker(Landscape, [])], strategy: :one_for_one)
    Supervisor.start_link [], strategy: :one_for_one
  end
end
