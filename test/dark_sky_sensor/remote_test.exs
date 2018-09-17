defmodule DarkSkySensor.RemoteTest do
  use ExUnit.Case
  doctest DarkSkySensor

  alias DarkSkySensor.Remote

  describe "setup_context" do
    test "it adds remote_name to the data" do
      arem = DarkSkySensor.Remote.setup_context(%Remote{name: "a_name"})

      assert arem.remote_name == :"DarkSkySensor.Remote_a_name"
    end
  end
end
