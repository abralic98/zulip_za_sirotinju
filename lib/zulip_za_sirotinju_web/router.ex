defmodule ZulipZaSirotinjuWeb.Router do
  use ZulipZaSirotinjuWeb, :router


  pipeline :graphql do
    plug ZulipZaSirotinjuWeb.Context
  end

  scope "/api" do
    scope "/graphql" do
      pipe_through(:graphql)

      forward("/", Absinthe.Plug, schema: Graphql.Schemas.Schema)
    end

    if System.fetch_env!("RELEASE_LEVEL") == "dev" do
      forward("/graphiql", Absinthe.Plug.GraphiQL, schema: Graphql.Schemas.Schema)
    end
  end

  # # Enable Swoosh mailbox preview in development
  # if Application.compile_env(:zulip_za_sirotinju, :dev_routes) do

  #   scope "/dev" do
  #     pipe_through [:fetch_session, :protect_from_forgery]

  #     forward "/mailbox", Plug.Swoosh.MailboxPreview
  #   end
  # end
end
