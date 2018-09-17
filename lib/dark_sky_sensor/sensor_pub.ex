defmodule DarkSkySensor.SensorPub do
  require Logger

  alias Scenic.Sensor
  alias DarkSkySensor.Remote

  @all_queries [:currently, :daily, :hourly, :minutely]
  @version "0.5.0"
  @description "Access the Dark Sky API for weather data"

  def setup_context(%Remote{} = args) do
    %{
      args
      | registered_names: generated_sensor_names(args)
    }
  end

  def register(%Remote{registered_names: registered_names}) do
    Enum.each(registered_names, fn {_query, register_name} ->
      Sensor.register(register_name, @version, @description)
    end)
  end

  def publish(%Remote{registered_names: registered_names}, data) do
    Enum.each(registered_names, fn {query, register_name} ->
      query_data = Map.fetch!(data, Atom.to_string(query))
      Sensor.publish(register_name, query_data)

      Logger.info("DarkSkySensor.Sensor publishing #{inspect(register_name)}")
    end)
  end

  defp generated_sensor_names(%Remote{blocking: blocking, name: name}) do
    @all_queries
    |> Enum.reject(fn x -> Enum.member?(blocking, x) end)
    |> Enum.reduce(%{}, fn q, acc -> Map.put(acc, q, sensor_name(q, name)) end)
  end

  defp sensor_name(query, :default), do: String.to_atom("dark_sky_#{query}")
  defp sensor_name(query, name), do: String.to_atom("dark_sky_#{query}_#{name}")
end
