use Mix.Config

config :zulip_za_sirotinju, ZulipZaSirotinjuWeb.Endpoint,
  http: [port: 4000],
  url: [host: "116.203.201.51", port: 4000],
  server: true,
  root: ".",
  version: Mix.Project.config()[:version]

config :logger, level: :info

config :swoosh, local: true

config :cors_plug,
  origin: [
    "http://116.203.201.51:4000",
    "http://116.203.201.51:4000/",
    "http://localhost:3002",
    "http://localhost:3003",
    "http://localhost:3003/",
    "http://localhost:3000",
    "http://localhost:3000/"
    "http://116.203.201.51:3000",
    "http://116.203.201.51:3000/",
    "http://116.203.201.51:3002/",
    "http://116.203.201.51:3002",
  ],
  methods: ["GET", "POST", "FETCH", "OPTIONS"]
