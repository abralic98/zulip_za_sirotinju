defmodule Graphql.Mutations.DeleteRoom do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Room

  def resolve(%{id: id}, _info) do
    case Repo.get(Room, id) do
      nil ->
        {:error, "Room does not exist"}

      room ->
        Repo.delete!(room)
        {:ok, room}
    end
  end
end
