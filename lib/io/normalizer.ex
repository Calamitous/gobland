defmodule Normalizer do
  @speed ~w(speed s)
  @clear ~w(clear cls c)
  @boom  ~w(boom)
  @time  ~w(time t)
  @quit  ~w(quit q)
  @map   ~w(map m)
  # @all List.flatten [@speed, @clear, @boom, @time, @quit]

  def normalize([command, value]) when command in @speed, do: [:speed, value]
  def normalize([command])        when command in @speed, do: :speed
  def normalize([command])        when command in @clear, do: :clear
  def normalize([command])        when command in @boom,  do: :boom
  def normalize([command])        when command in @time,  do: :time
  def normalize([command])        when command in @quit,  do: :quit
  def normalize([command])        when command in @map,   do: :map
  # def normalize(["shutdown"]), do: :shutdown

  def normalize(command), do: command
end
