defmodule Graphql.Queries.GetMessagesByRoomId do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Message
  alias Schemas.Account
  import Ecto.Query, warn: false
  alias Absinthe.Relay.Connection

  def resolve(_, args, _context) do
    messages =
      Message
      |> where([m], m.room_id == ^args.room_id)
      |> order_by([p], desc: p.inserted_at)
      |> preload(account: :avatar)
      |> Connection.from_query(
        &Repo.all/1,
        default_pagination(args)
      )
  end

  defp default_pagination(%{:last => _} = data), do: data

  defp default_pagination(data), do: Map.put_new(data, :first, 1000)
end
