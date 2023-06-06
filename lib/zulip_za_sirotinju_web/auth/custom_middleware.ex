defmodule ZulipZaSirotinjuWeb.Auth.CustomMiddleware do
  defmacro __using__(_) do
    quote do
      # alias ZulipZaSirotinjuWeb.API.Graphql.Middleware
      alias ZulipZaSirotinjuWeb.Auth.RequireAuth

      def middleware(middleware, field, object) do
        if Enum.member?(
             [
               :create_session,
               :create_account,
               :id,
               :token,
               :get_messages_by_room_id_subscription
             ],
             field.identifier
           ) or field.identifier === :session or
             field.__reference__.module === Absinthe.Type.BuiltIns.Introspection do
          middleware
        else
          [RequireAuth] ++ middleware
        end
      end
    end
  end
end
