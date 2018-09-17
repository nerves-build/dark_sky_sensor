defmodule DarkSkySensor do
  @moduledoc """
  Documentation for DarkSkySensor.
  """

  alias DarkSkySensor.Remote

  def start_remote(_name, _args) do
  end

  def get_state(name) do
    Remote.get_state(name)
  end

  def set_location(name, lat, lng) do
    state =
      Remote.set_state(name, %{
        latitude: lat,
        longitude: lng
      })

    {:ok, {state.latitude, state.longitude}}
  end
end
