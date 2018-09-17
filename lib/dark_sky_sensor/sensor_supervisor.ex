defmodule DarkSkySensor.SensorSupervisor do
  use DynamicSupervisor

  alias DarkSkySensor.Remote
  alias DarkSkySensor.Sensor

  def start_link([]) do
    DynamicSupervisor.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(%{}) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_sensor(args) do
    DynamicSupervisor.start_child(__MODULE__, {Sensor, args})
  end

  def get_sensor(name) do
    case get_sensor_pid(name) do
      {:ok, _pid, sensor} -> sensor
      _error -> nil
    end
  end

  def remove_sensor(%Remote{name: name}) do
    remove_sensor(name)
  end

  def remove_sensor(name) do
    case get_sensor_pid(name) do
      {:ok, pid, _sensor} ->
        DynamicSupervisor.terminate_child(__MODULE__, pid)

      _ ->
        :err
    end
  end

  def children do
    DynamicSupervisor.which_children(__MODULE__)
  end

  def count_children do
    DynamicSupervisor.count_children(__MODULE__)
  end

  defp get_sensor_pid(name) do
    Enum.find_value(children(), {:err, :not_found}, fn c ->
      {_id, pid, _type, _workers} = c
      sensor = GenServer.call(pid, :get_state)

      if sensor.name == name do
        {:ok, pid, sensor}
      else
        false
      end
    end)
  end
end
