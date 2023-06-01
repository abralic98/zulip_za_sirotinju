defmodule ZulipZaSirotinju.GraphqlSocket do
  use Phoenix.Socket

  use Absinthe.Phoenix.Socket,
    schema: Graphql.Schemas.Schema

  alias ZulipZaSirotinju.Repo
  alias Absinthe.Phoenix.Socket, as: AbsintheSocket
  alias Schemas.Account

  # def connect(params, socket) do
  #   current_user = current_user(params)
  #   IO.inspect(socket)

  #   socket =
  #     AbsintheSocket.put_options(
  #       socket,
  #       [
  #         current_user
  #       ]
  #     )

  #   {:ok, socket}
  # end

  # defp current_user(id) do
  #   {:ok, Repo.get(Account, 1)}
  # end

  def connect(params, socket) do
    IO.puts("KITA")

    current_user = current_user(params)
    # current_user = %{context: %{current_user: current_user}}
    IO.inspect(current_user)
    socket =
      Absinthe.Socket.put_options(socket,
        context: %{
          current_user: current_user
        }
      )

    {:ok, socket}
  end

  defp current_user(id) do
     {:ok, Repo.get(Account, id)}
  end

  def id(_socket), do: nil
end
