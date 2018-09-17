defmodule DarkSkySensor.SensorTest do
  use ExUnit.Case
  doctest DarkSkySensor

  alias DarkSkySensor.Remote
  alias DarkSkySensor.Sensor

  setup do
    %{
      remote: %Remote{name: "a_name"}
    }
  end

  describe "setup_context" do
    test "it adds sensor_name to the data", %{remote: remote} do
      subject = Sensor.setup_context(remote)
      assert subject.sensor_name == :"DarkSkySensor.Sensor_a_name"
    end
  end
end
