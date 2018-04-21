# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :frmwrk,
  ecto_repos: [Frmwrk.Repo]

# Configures the endpoint
config :frmwrk, FrmwrkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("ENDPOINT_SECRET_KEY"),
  render_errors: [view: FrmwrkWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Frmwrk.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Config Bcrypt
config :bcrypt_elixir, :log_rounds, 4

# Config Guardian
config :frmwrk, Frmwrk.Auth.Guardian,
  issuer: "frmwrk",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
