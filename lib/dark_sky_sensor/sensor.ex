defmodule DarkSkySensor.Sensor do
  use GenServer

  require Logger

  alias DarkSkySensor.{DarkSkyApi, Remote, SensorPub}

  def start_link(%Remote{sensor_name: sensor_name} = args) do
    GenServer.start_link(__MODULE__, args, name: sensor_name)
  end

  def setup_context(%Remote{name: name} = args) do
    %{args | sensor_name: :"DarkSkySensor.Sensor_#{name}"}
  end

  def get_state(remote_name), do: GenServer.call(remote_name, :get_state)

  def init(%Remote{remote_name: remote_name}) do
    state = Remote.get_state(remote_name)

    SensorPub.register(state)
    spawn_tick(%Remote{interval: 1000})

    {:ok, state}
  end

  def handle_info(:tick, %Remote{} = state) do
    case DarkSkyApi.get(state) do
      {:error, %DarkSkySensor.Error{reason: reason}} ->
        Logger.error("API Error #{inspect(reason)}")

      {:ok, reply} ->
        case DarkSkyApi.parse_reply(reply) do
          {:err, reason} ->
            Logger.error(reason)

          data ->
            SensorPub.publish(state, data)
        end

      err ->
        Logger.error("DarkSkySensor.Sensor error #{inspect(err)}")
    end

    spawn_tick(state)

    {:noreply, state}
  end

  def handle_call(:get_state, _from, state),
    do: {:reply, state, state}

  defp spawn_tick(%Remote{interval: interval}) do
    parent = self()
    spawn(fn -> Process.send_after(parent, :tick, interval) end)
  end
end
