use Mix.Config

# Configures environment variables. There is a good chance you only want to touch this section
config :profile_place,
  db_url: System.fetch_env!("DB_URL"),
  discord_id: System.fetch_env!("DISCORD_ID"),
  discord_secret: System.fetch_env!("DISCORD_SECRET"),
  discord_redirect: System.fetch_env!("DISCORD_REDIRECT"),
  spotify_id: System.fetch_env!("SPOTIFY_ID"),
  spotify_secret: System.fetch_env!("SPOTIFY_SECRET"),
  spotify_redirect: System.fetch_env!("SPOTIFY_REDIRECT")

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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
