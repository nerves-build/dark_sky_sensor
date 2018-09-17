defmodule DarkSkySensor.DarkSkyApi do
  @url_base "https://api.darksky.net/forecast"

  def get(state) do
    state
    |> full_url
    |> HTTPoison.get()
    |> case do
      {:error, %HTTPoison.Error{id: id, reason: reason}} ->
        {:error, %DarkSkySensor.Error{id: id, reason: reason}}

      {:ok, reply} ->
        {:ok, reply}
    end
  end

  def parse_reply(%{status_code: 200} = reply) do
    case Poison.Parser.parse(reply.body) do
      {:ok, data} ->
        data

      err ->
        {:err, "parse error #{inspect(err)}"}
    end
  end

  def parse_reply(reply) do
    {:err, "fetch error #{inspect(reply.status_code)} #{inspect(reply.body)}"}
  end

  defp full_url(%{key: key, latitude: lat, longitude: lng, blocking: blocking}) do
    "#{@url_base}/#{key}/#{lat},#{lng}?exclude=#{Enum.join(blocking, ",")}"
  end
end
