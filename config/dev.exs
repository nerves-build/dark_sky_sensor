use Mix.Config

config :logger, :console, format: "[$level] $message\n"

import_config "dev.secret.exs"
