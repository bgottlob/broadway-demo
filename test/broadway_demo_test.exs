defmodule BroadwayDemoTest do
  use ExUnit.Case
  doctest BroadwayDemo

  test "greets the world" do
    assert BroadwayDemo.hello() == :world
  end
end
