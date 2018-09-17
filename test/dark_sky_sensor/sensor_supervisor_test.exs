defmodule DarkSkySensor.SensorSupervisorTest do
  use ExUnit.Case

  alias DarkSkySensor.RemoteSupervisor
  alias DarkSkySensor.SensorSupervisor
  alias DarkSkySensor.Support.TestUtilities

  describe "child sensors" do
    setup do
      remote = TestUtilities.build_remote("a_name")
      RemoteSupervisor.add_remote(remote)

      SensorSupervisor.add_sensor(remote)

      on_exit(fn ->
        SensorSupervisor.remove_sensor(remote)
      end)

      %{remote: remote}
    end

    test "can be created", %{remote: remote} do
      assert SensorSupervisor.get_sensor(remote.name)
    end

    test "can be removed", %{remote: remote} do
      assert SensorSupervisor.get_sensor(remote.name)
      SensorSupervisor.remove_sensor(remote.name)

      refute SensorSupervisor.get_sensor("a_name")
    end

    test "can be fetched", %{remote: remote} do
      fetched_sensor = SensorSupervisor.get_sensor(remote.name)
      assert fetched_sensor.name == remote.name
    end

    test "created sensor is supervised", %{remote: remote} do
      assert SensorSupervisor.get_sensor("a_name")
      GenServer.stop(remote.sensor_name)
      assert SensorSupervisor.get_sensor("a_name")
    end
  end
end
