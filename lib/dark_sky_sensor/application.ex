defmodule DarkSkySensor.Application do
  @moduledoc false

  alias DarkSkySensor.RemoteManager
  alias DarkSkySensor.RemoteSupervisor
  alias DarkSkySensor.SensorSupervisor

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Scenic.Sensor, nil},
      {RemoteSupervisor, []},
      {SensorSupervisor, []},
      {RemoteManager, []}
    ]

    opts = [strategy: :one_for_one, name: DarkSkySensor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
