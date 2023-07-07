defmodule Graphql.Mutations.AccessProtectedRoom do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Room

  def resolve(_, %{room_id: room_id, password: password}, _) do
    case Repo.get_by(Room, id: room_id) do
      nil ->
        {:error, "Could not find room"}

      room ->
        {:ok, room.password == password}
    end
  end
end
