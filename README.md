# Gobland

Gobland is a telnet-based landscape simulator.

## Server
Run it as follows:

```
mix
```

This runs a telnet server on port 6000.

## Connecting
You should be able to connect to it:

```
telnet localhost 6000
```

## Commands

Commands are entered from the prompt.  Most commands can be replaced with their first letter (ie. `m` instead of `map` and so on).

Currently the following commands are implemented...ish:

----

`map`

Display or update the map.

----

`time`

Display or update the current time and date.

----

`speed`

Display how much sim time passes with each real second.

----

`speed [value]`

Change how much sim time passes with each real second.  Valid values are `pause`, `minute`, `hour`, `day`, and `season`.

----

`clear`

Clear the screen.

----

`rain`

Add flowing water to a random location on the map.

----

`quit`

Exit the Gobland session.

