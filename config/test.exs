import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :spaced_rep, SpacedRep.Repo,
  username: "postgres",
  password: "spaced-repetition",
  hostname: "db",
  database: "spaced_rep_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :spaced_rep, SpacedRepWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Luk2gRGLW1eznCKBl2WOtjHS64/eCNXaBn+TU6FPnH/DFyWWXKbJzeV71KfTwlec",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
