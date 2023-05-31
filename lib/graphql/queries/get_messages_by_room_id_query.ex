defmodule Graphql.Queries.GetMessagesByRoomId do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Message

  def resolve(_, args, _context) do
    response =
      Repo.all(Message, room_id: args.room_id)
      |> Repo.preload(:account)

    {:ok, response}
  end
end
