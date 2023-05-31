defmodule Graphql.Mutations.UpdateRoom do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Room

  def resolve(_, %{id: id, input: update_room_params}, _context) do
    Repo.get(Room, id)
    |> Room.changeset(update_room_params)
    |> Repo.update()
  end
end
