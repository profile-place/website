defmodule ProfilePlace.MixProject do
  use Mix.Project

  def project do
    [
      app: :profile_place,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ProfilePlace.Application, []},
      extra_applications: [:logger, :runtime_tools, :snowflake, :dotenv, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.12"},
      {:phoenix_html, "~> 3.0.3"},
      {:phoenix_live_reload, "~> 1.3.3", only: :dev},
      {:phoenix_live_dashboard, "~> 0.5.1"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:telemetry_poller, "~> 0.4"},
      {:jason, "~> 1.2.2"},
      {:plug_cowboy, "~> 2.5.2"},
      {:mongodb, "~> 0.5.1"},
      {:snowflake, "~> 1.0.4"},
      {:redix, "~> 1.1.4"},
      {:argon2_elixir, "~> 2.4.0"},
      {:dotenv, "~> 3.1.0"},
      {:httpoison, "~> 1.8.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm ci --prefix assets"],
      startthisfuckingshit: ["phx.server"]
    ]
  end
end
