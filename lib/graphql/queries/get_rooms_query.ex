defmodule Graphql.Queries.GetRooms do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Room

  def resolve(_, _, _) do
    {:ok, Repo.all(Room)}
  end
end
