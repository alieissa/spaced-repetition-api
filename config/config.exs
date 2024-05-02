# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :spaced_rep,
  ecto_repos: [SpacedRep.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :spaced_rep, SpacedRepWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: SpacedRepWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SpacedRep.PubSub,
  live_view: [signing_salt: "tj6LfHqb"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_aws,
  access_key_id: {:system, "AWS_S3_ACCESS_KEY"},
  secret_access_key: {:system, "AWS_S3_SECRET_ACCESS_KEY"},
  region: {:system, "AWS_REGION"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
