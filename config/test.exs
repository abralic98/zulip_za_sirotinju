import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :zulip_za_sirotinju, ZulipZaSirotinju.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "zulip_za_sirotinju_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :zulip_za_sirotinju, ZulipZaSirotinjuWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "CgN9uqDWLNMX3ERxfVZDh8hJ9U178oCYTCx2ebMk/wh5kQU3K4YcJRI6P+FaxUOX",
  server: false

# In test we don't send emails.
config :zulip_za_sirotinju, ZulipZaSirotinju.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
