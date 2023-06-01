defmodule ZulipZaSirotinju.GraphqlSocket do
  use Phoenix.Socket

  use Absinthe.Phoenix.Socket,
    schema: Graphql.Schemas.Schema

  alias ZulipZaSirotinju.Repo
  alias Absinthe.Phoenix.Socket, as: AbsintheSocket
  alias Schemas.Account

  def connect(params, socket) do
    current_user = current_user(params)
    IO.inspect(socket)

    socket =
      AbsintheSocket.put_options(
        socket,
        [
          current_user
        ]
      )

    {:ok, socket}
  end

  defp current_user(id) do
    {:ok, Repo.get(Account, 1)}
  end

  def id(_socket), do: nil
end
