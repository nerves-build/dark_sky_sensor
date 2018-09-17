defmodule DarkSkySensor.RemoteManager do
  use GenServer

  alias DarkSkySensor.RemoteSupervisor
  alias DarkSkySensor.SensorSupervisor
  alias DarkSkySensor.Remote
  alias DarkSkySensor.SensorPub
  alias DarkSkySensor.Sensor

  def start_link(_args) do
    state = Map.merge(%Remote{}, user_config_map())

    GenServer.start_link(__MODULE__, state, name: DarkSkySensor.RemoteManager)
  end

  def init(state) do
    start_named_remote(state, :default)
    start_remotes(state)

    {:ok, state}
  end

  def start_remotes(%Remote{remotes: remotes} = args) do
    for {name, remote_args} <- remotes do
      args
      |> Map.merge(remote_args)
      |> start_named_remote(name)
    end
  end

  def start_named_remote(%Remote{latitude: nil}, _name), do: :err
  def start_named_remote(%Remote{longitude: nil}, _name), do: :err

  def start_named_remote(%Remote{} = args, name) do
    args
    |> Map.merge(%{name: name})
    |> setup_context
    |> launch_apps

    :ok
  end

  defp launch_apps(%Remote{auto_start: true} = args) do
    RemoteSupervisor.add_remote(args)
    SensorSupervisor.add_sensor(args)
  end

  defp launch_apps(%Remote{} = args) do
    RemoteSupervisor.add_remote(args)
  end

  defp setup_context(%Remote{} = args) do
    args
    |> Remote.setup_context()
    |> SensorPub.setup_context()
    |> Sensor.setup_context()
  end

  defp user_config_map do
    (Application.get_env(:dark_sky_sensor, :settings) || [])
    |> Enum.reduce(%{}, fn {key, val}, acc -> Map.put(acc, key, val) end)
  end
end
