# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :profile_place, ProfilePlaceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7ozIfPKRgOELU+HOyg0vuhEr6ZMh0gdnySmE1sZ+G/7xSrwfr5lwkXlMTIOawyPC",
  render_errors: [view: ProfilePlaceWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ProfilePlace.PubSub,
  live_view: [signing_salt: "wJ2RsDFD"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :snowflake,
  nodes: ["127.0.0.1"],
  epoch: 1_577_836_800_000

config :profile_place,
  db_url: System.get_env("DATABASE_URL")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
import_config "secret.exs"
