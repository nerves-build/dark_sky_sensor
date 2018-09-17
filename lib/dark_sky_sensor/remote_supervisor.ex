defmodule DarkSkySensor.RemoteSupervisor do
  use DynamicSupervisor

  alias DarkSkySensor.Remote

  def start_link([]) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def get_remote(name) do
    case get_remote_pid(name) do
      {:ok, _pid, remote} -> remote
      _error -> nil
    end
  end

  def add_remote(args) do
    DynamicSupervisor.start_child(__MODULE__, {Remote, args})
  end

  def remove_remote(%Remote{name: name}) do
    remove_remote(name)
  end

  def remove_remote(name) do
    case get_remote_pid(name) do
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

  defp get_remote_pid(name) do
    Enum.find_value(children(), {:err, :not_found}, fn c ->
      {_id, pid, _type, _workers} = c
      remote = GenServer.call(pid, :get_state)

      if remote.name == name do
        {:ok, pid, remote}
      else
        false
      end
    end)
  end
end
