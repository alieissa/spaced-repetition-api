import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/spaced_rep start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :spaced_rep, SpacedRepWeb.Endpoint, server: true
end

if config_env() == :prod || config_env() == :dev do
  config :spaced_rep, SpacedRep.Repo,
    hostname:
      System.get_env("DB_HOSTNAME") || raise("Environment variable DB_HOSTNAME is not set."),
    database: System.get_env("DB_NAME") || raise("Environment variable DB_NAME is not set."),
    username:
      System.get_env("DB_USERNAME") || raise("Environment variable DB_USERNAME is not set."),
    password:
      System.get_env("DB_PASSWORD") || raise("Environment variable DB_PASSWORD is not set."),
    pool_size: 10

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :spaced_rep, SpacedRepWeb.Endpoint,
    http: [
      ip: {0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base

  config :ex_aws,
    access_key_id:
      System.get_env("AWS_S3_ACCESS_KEY") ||
        raise("Environment variable AWS_S3_ACCESS_KEY is not set."),
    secret_access_key:
      System.get_env("AWS_S3_SECRET_ACCESS_KEY") ||
        raise("Environment variable AWS_S3_SECRET_ACCESS_KEY is not set."),
    region: System.get_env("REGION") || raise("Environment variable REGION is not set.")

  # ## SSL Support
  #
  # To get SSL working, you will need to add the `https` key
  # to your endpoint configuration:
  #
  #     config :spaced_rep, SpacedRepWeb.Endpoint,
  #       https: [
  #         ...,
  #         port: 443,
  #         cipher_suite: :strong,
  #         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
  #         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
  #       ]
  #
  # The `cipher_suite` is set to `:strong` to support only the
  # latest and more secure SSL ciphers. This means old browsers
  # and clients may not be supported. You can set it to
  # `:compatible` for wider support.
  #
  # `:keyfile` and `:certfile` expect an absolute path to the key
  # and cert in disk or a relative path inside priv, for example
  # "priv/ssl/server.key". For all supported SSL configuration
  # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
  #
  # We also recommend setting `force_ssl` in your endpoint, ensuring
  # no data is ever sent via http, always redirecting to https:
  #
  #     config :spaced_rep, SpacedRepWeb.Endpoint,
  #       force_ssl: [hsts: true]
  #
  # Check `Plug.SSL` for all available options in `force_ssl`.
end
