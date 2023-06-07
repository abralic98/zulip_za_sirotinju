# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :zulip_za_sirotinju,
  ecto_repos: [ZulipZaSirotinju.Repo]

# Configures the endpoint
config :zulip_za_sirotinju, ZulipZaSirotinjuWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: ZulipZaSirotinjuWeb.ErrorJSON],
    layout: false
  ],
  # pubsub_server: [name: ZulipZaSirotinju.PubSub, adapter: Phoenix.PubSub.PG2],
  pubsub_server: ZulipZaSirotinju.PubSub,
  live_view: [signing_salt: "CQU6u+//"]

config :joken, default_signer: "secret"

config :cors_plug,
  origin: [
    "http://localhost:3000/",
    "http://localhost:3002",
    "http://localhost:3000",
    "http://localhost:3002/",
    "http://localhost:3003/",
    "http://localhost:3003",
  ],
  methods: ["GET", "POST", "FETCH", "OPTIONS"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.

# config :zulip_za_sirotinju,
#        mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
#        mailgun_key: System.get_env("MAILGUN_API_KEY")

config :zulip_za_sirotinju, ZulipZaSirotinju.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config :absinthe, :schema, force_compile: true
# config :absinthe, :schema, caching: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
