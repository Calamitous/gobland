defmodule Calendar do
  use GenServer
  @season_progression %{:spring => :summer, :summer => :fall, :fall => :winter, :winter => :spring}
  @season_length 30
  @advancement_speeds  %{:pause => 0, :minute => 1, :hour => 60, :day => 60 * 24, :season => 60 * 24 * @season_length}

  def start_link, do: GenServer.start_link(__MODULE__, nil, name: :calendar)
  def start, do: GenServer.start(__MODULE__, nil, name: :calendar)

  def init(_) do
    :timer.send_interval(1000, :advance)
    {:ok, {1, :spring, 1, 8, 0, :minute}}
  end

  def handle_info(:advance, state),   do: {:noreply, advance(state)}
  def handle_call(:glance, _, state), do: {:reply, date_format(state), state}
  def handle_call(:season, _, state), do: {:reply, season_format(state), state}
  def handle_call({:set_speed, new_speed}, _, {y, season, d, h, m, _}) do
    {:reply, "Set speed to #{new_speed}", {y, season, d, h, m, new_speed}}
  end
  def handle_call(:get_speed, _, {y, season, d, h, m, speed}) do
    {:reply, Atom.to_string(speed), {y, season, d, h, m, speed}}
  end

  def boom(), do: raise "HAHA K'BOOM"
  def glance, do: GenServer.call(:calendar, :glance)
  def season, do: GenServer.call(:calendar, :season)
  def set_speed(new_speed), do: GenServer.call(:calendar, {:set_speed, String.to_atom(new_speed)})
  def get_speed(), do: GenServer.call(:calendar, :get_speed)

  def notify_watchers(state) do
    Landscape.advance
    state
  end

  def advance(state, 0), do: state
  def advance(state, times), do: state |> next_minute |> advance(times - 1)
  def advance({y, season, d, h, m, speed}) do
    advance({y, season, d, h, m, speed}, @advancement_speeds[speed])
    |> notify_watchers
  end

  def next_minute({y, season, d, h, m, speed}) when m >= 59, do: next_hour({y, season, d, h, 0, speed})
  def next_minute({y, season, d, h, m, speed}),              do: {y, season, d, h, m + 1, speed}

  def next_hour({y, season, d, h, m, speed}) when h >= 23, do: next_day({y, season, d, 0, m, speed})
  def next_hour({y, season, d, h, m, speed}),              do: {y, season, d, h + 1, m, speed}

  def next_day({y, season, d, h, m, speed}) when d >= @season_length, do: next_season({y, season, 1, h, m, speed})
  def next_day({y, season, d, h, m, speed}),                          do: {y, season, d + 1, h, m, speed}

  def next_season({y, :winter, d, h, m, speed}), do: {y + 1, @season_progression[:winter], d, 0, 0, speed}
  def next_season({y, season, d, h, m, speed}),  do: {y, @season_progression[season], d, 0, 0, speed}

  def season_string(season), do: season |> to_string |> String.capitalize

  def day_icon(hour) when hour >= 7 and hour < 19, do: [IO.ANSI.yellow, '☀', IO.ANSI.reset] #  '\u2600' #
  def day_icon(_),                                 do: [IO.ANSI.white,  '☾', IO.ANSI.reset]

  def season_format({_, season, _, _, _, _}), do: season

  def date_format({y, season, d, h, m, _}) do
    [formatted_hours, formatted_minutes] = [String.rjust(to_string(h), 2, ?0), String.rjust(to_string(m), 2, ?0)]
    "#{day_icon(h)} #{formatted_hours}:#{formatted_minutes} #{season_string(season)} #{d}, Year #{y}"
  end
end
