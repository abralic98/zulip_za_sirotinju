defmodule Graphql.Mutations.CreateRoom do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Room

  def resolve(_root, %{input: create_room_input}, _context) do
    %Room{}
    |> Room.changeset(create_room_input)
    |> Repo.insert()
  end
end
