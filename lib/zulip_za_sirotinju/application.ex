defmodule ZulipZaSirotinju.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      # ZulipZaSirotinjuWeb.Telemetry,
      # Start the Ecto repository
      ZulipZaSirotinju.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ZulipZaSirotinju.PubSub},
      # Start Finch
      # {Finch, name: ZulipZaSirotinju.Finch},
      # Start the Endpoint (http/https)
      ZulipZaSirotinjuWeb.Endpoint,
      # Start a worker by calling: ZulipZaSirotinju.Worker.start_link(arg)
      # {ZulipZaSirotinju.Worker, arg}

      {Absinthe.Subscription, pubsub: ZulipZaSirotinjuWeb.Endpoint}
    ]

    opts = [strategy: :one_for_one, name: ZulipZaSirotinju.Supervisor]
    Supervisor.start_link(children, opts)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    # opts = [strategy: :one_for_one, name: ZulipZaSirotinju.Supervisor]
    # Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ZulipZaSirotinjuWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
