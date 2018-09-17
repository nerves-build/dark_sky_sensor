defmodule DarkSkySensor.Remote do
  defstruct name: nil,
            registered_names: nil,
            remotes: [],
            remote_name: nil,
            sensor_name: nil,
            blocking: [:minutely, :hourly],
            interval: 1000 * 60 * 15,
            auto_start: true,
            latitude: nil,
            key: nil,
            longitude: nil

  use GenServer
  require Logger

  alias DarkSkySensor.Remote

  def start_link(%Remote{remote_name: remote_name} = args),
    do: GenServer.start_link(__MODULE__, args, name: remote_name)

  def setup_context(%Remote{name: name} = args),
    do: %{args | remote_name: :"DarkSkySensor.Remote_#{name}"}

  def get_state(remote_name), do: GenServer.call(remote_name, :get_state)

  def set_state(remote_name, new_state),
    do: GenServer.call(remote_name, {:set_state, new_state})

  def init(%Remote{} = state),
    do: {:ok, state}

  def handle_call(:get_state, _from, state),
    do: {:reply, state, state}

  def handle_call({:set_state, new_state}, _from, state) when is_map(new_state) do
    state = Map.merge(state, new_state)

    {:reply, state, state}
  end

  def handle_call({:set_state, new_state}, _from, state) do
    Logger.warn("incorrect param, not a map - #{inspect(new_state)}")

    {:reply, state, state}
  end
end
