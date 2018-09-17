defmodule DarkSkySensor.Support.TestUtilities do
  alias DarkSkySensor.Remote
  alias DarkSkySensor.Sensor
  alias DarkSkySensor.SensorPub

  def build_remote(name) do
    remote =
      %Remote{name: name}
      |> Remote.setup_context()
      |> Sensor.setup_context()
      |> SensorPub.setup_context()

    remote
  end
end
