defmodule Graphql.Queries.GetMessagesByRoomId do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Message
  import Ecto.Query, warn: false
  # ovo treba za custom query

  def resolve(_, args, _context) do
    query = from m in Message, where: m.room_id == ^args.room_id
    response =
      Repo.all(query)
      |> Repo.preload(:account)

    {:ok, response}
  end
end
