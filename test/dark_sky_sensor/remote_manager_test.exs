defmodule DarkSkySensor.RemoteManagerTest do
  use ExUnit.Case

  alias DarkSkySensor.Remote
  alias DarkSkySensor.RemoteSupervisor
  alias DarkSkySensor.SensorSupervisor
  alias DarkSkySensor.RemoteManager
  alias DarkSkySensor.Support.TestUtilities

  @name "a_name"

  describe "starts remotes" do
    setup do
      remote = TestUtilities.build_remote("a_name")

      on_exit(fn ->
        RemoteSupervisor.remove_remote(remote)
      end)

      %{remote: remote}
    end

    test "are not created without proper information", %{remote: %Remote{} = remote} do
      RemoteManager.start_named_remote(remote, @name)

      refute RemoteSupervisor.get_remote(@name)
    end

    test "can be created with proper information", %{remote: %Remote{} = remote} do
      remote = %Remote{remote | latitude: 37.4, longitude: 110.3}
      RemoteManager.start_named_remote(remote, @name)

      assert RemoteSupervisor.get_remote(@name)
    end

    test "can be removed", %{remote: %Remote{} = remote} do
      remote = %Remote{remote | latitude: 37.4, longitude: 110.3}
      RemoteManager.start_named_remote(remote, @name)

      assert RemoteSupervisor.get_remote(@name)
      RemoteSupervisor.remove_remote(@name)

      refute RemoteSupervisor.get_remote(@name)
    end
  end

  describe "starts sensors" do
    setup do
      remote = TestUtilities.build_remote("a_name")
      remote = %Remote{remote | latitude: 37.4, longitude: 110.3, key: "secret"}

      on_exit(fn ->
        RemoteSupervisor.remove_remote(remote)
        SensorSupervisor.remove_sensor(remote)
        Process.sleep(10)
      end)

      %{remote: remote}
    end

    test "are not created without auto_start being true", %{remote: %Remote{} = remote} do
      remote = %Remote{remote | auto_start: false}
      RemoteManager.start_named_remote(remote, @name)

      refute SensorSupervisor.get_sensor(@name)
    end

    test "are created when auto_start is true", %{remote: %Remote{} = remote} do
      RemoteManager.start_named_remote(remote, @name)

      assert SensorSupervisor.get_sensor(@name)
    end

    test "run supervised", %{remote: %Remote{} = remote} do
      RemoteManager.start_named_remote(remote, @name)

      assert SensorSupervisor.get_sensor(@name)
      GenServer.stop(remote.sensor_name)

      assert SensorSupervisor.get_sensor(@name)
    end

    test "update their state from their remote when restarted", %{remote: %Remote{} = remote} do
      RemoteManager.start_named_remote(remote, @name)

      sensor = SensorSupervisor.get_sensor(@name)
      assert sensor.longitude == 110.3

      Remote.set_state(remote.remote_name, %{longitude: 70})
      GenServer.stop(remote.sensor_name)

      sensor = SensorSupervisor.get_sensor(@name)
      assert sensor.longitude == 70
    end
  end
end
