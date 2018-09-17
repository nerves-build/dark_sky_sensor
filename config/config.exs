use Mix.Config

config :dark_sky_sensor, :settings,
  latitude: "40.9",
  longitude: "-73.1",
  interval: 1000 * 60 * 15,
  polling: false,
  auto_start: true,
  remotes: %{
    phoenix: %{
      latitude: "33.2",
      longitude: "-111.8"
    },
    edmonton: %{
      latitude: "53.4",
      longitude: "-113.4"
    },
    london: %{
      latitude: "51.5",
      longitude: "-0.1"
    }
  }

config :logger, level: :debug

import_config "#{Mix.env()}.exs"
