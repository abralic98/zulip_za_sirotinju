defmodule Graphql.Mutations.CreateRoom do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Room

  def resolve(_root, %{input: create_room_input}, _context) do
    password = create_room_input.password
    is_password_protected = !is_nil(password)

    modified = Map.put(create_room_input, :is_password_protected, is_password_protected)
    IO.inspect(modified, label: "MODIFIEd")

    {:ok, room} =
      %Room{}
      |> Room.changeset(modified)
      |> Repo.insert()

    Absinthe.Subscription.publish(ZulipZaSirotinjuWeb.Endpoint, room,
      get_rooms_subscription: "Rooms"
    )

    {:ok, room}
  end
end
