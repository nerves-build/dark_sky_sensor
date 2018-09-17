defmodule DarkSkySensor.RemoteSupervisorTest do
  use ExUnit.Case

  alias DarkSkySensor.RemoteSupervisor
  alias DarkSkySensor.Support.TestUtilities

  describe "child remotes" do
    setup do
      remote = TestUtilities.build_remote("a_name")
      RemoteSupervisor.add_remote(remote)

      %{remote: remote}
    end

    test "can be created", %{remote: remote} do
      assert RemoteSupervisor.get_remote(remote.name)
    end

    test "can be removed", %{remote: remote} do
      assert RemoteSupervisor.get_remote(remote.name)
      RemoteSupervisor.remove_remote(remote.name)

      refute RemoteSupervisor.get_remote("a_name")
    end

    test "can be fetched", %{remote: remote} do
      fetched_sensor = RemoteSupervisor.get_remote(remote.name)
      assert fetched_sensor.name == remote.name
    end

    test "created remote is supervised", %{remote: remote} do
      assert RemoteSupervisor.get_remote("a_name")
      GenServer.stop(remote.remote_name)
      assert RemoteSupervisor.get_remote("a_name")
    end
  end
end
