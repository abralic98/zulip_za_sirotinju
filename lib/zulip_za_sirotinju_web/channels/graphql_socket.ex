defmodule ZulipZaSirotinju.GraphqlSocket do
  use Phoenix.Socket

  use Absinthe.Phoenix.Socket,
    schema: ZulipZaSirotinju.Graphql.Schemas

  alias Absinthe.Phoenix.Socket, as: AbsintheSocket
  alias Schemas.Account

  def connect(params, socket) do
    current_user = current_user(params)

    socket =
      Absinthe.Phoenix.Socket.put_options(socket,
        context: %{
          current_user: current_user
        }
      )

    {:ok, socket}
  end

  defp current_user(%{"user_id" => id}) do
    Repo.get(Account, id)
  end

  def id(_socket), do: nil
end
