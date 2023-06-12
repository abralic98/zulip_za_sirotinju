defmodule Graphql.Mutations.CreateRoom do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Room

  def resolve(_root, %{input: create_room_input}, _context) do

    {:ok, room} =
    %Room{}
    |> Room.changeset(create_room_input)
    |> Repo.insert()

  Absinthe.Subscription.publish(ZulipZaSirotinjuWeb.Endpoint, room, get_rooms_subscription: "Rooms")

  {:ok, room}
  end
end
