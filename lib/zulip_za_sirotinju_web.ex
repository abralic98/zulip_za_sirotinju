defmodule ZulipZaSirotinjuWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use ZulipZaSirotinjuWeb, :controller
      use ZulipZaSirotinjuWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: ZulipZaSirotinjuWeb.Layouts]

      import Plug.Conn
      import ZulipZaSirotinjuWeb.Gettext

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: ZulipZaSirotinjuWeb.Endpoint,
        router: ZulipZaSirotinjuWeb.Router,
        statics: ZulipZaSirotinjuWeb.static_paths()
    end
  end

  @doc false
  def child_spec(_arg) do
    children = [
      {Phoenix.PubSub, name: ZulipZaSirotinju.PubSub},
      ZulipZaSirotinjuWeb.Endpoint,
      {Absinthe.Subscription, pubsub: ZulipZaSirotinjuWeb.Endpoint},
    ]

    %{
      id: __MODULE__,
      type: :supervisor,
      start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
    }
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
