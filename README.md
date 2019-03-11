# BroadwayDemo

A mix app to demonstrate use of the [Broadway](https://github.com/plataformatec/broadway/) behavior, combining some of the concepts shown in the [Broadway documentation](https://hexdocs.pm/broadway).

A producer, which is a simple `Counter` module implementing the `GenStage` behavior, produces incrementing integers. The `BroadwayDemo` module, which implements the `Broadway` behavior sets up two batchers for consuming those integers, one that handles odd integers and one that handles even integers. The integers are "handled" by simply printing them to stdout.

## Setup
Clone this repo, then run `mix deps.get`.

## Running
The easiest way to observe the output of the demo is to run it in an `iex` shell:
```
$ iex -S mix
Erlang/OTP 21 [erts-10.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> BroadwayDemo.start_link([])
```
