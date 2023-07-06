defmodule Graphql.Queries.GetUserAvatar do
  import Ecto.Query
  alias ZulipZaSirotinju.Repo
  alias Schemas.Avatar

  def resolve(_, _, %{context: %{current_user: current_user}}) do
    query =
      from(a in Avatar, where: a.account_id == ^current_user.id, order_by: [desc: a.inserted_at], limit: 1)

    {:ok, Repo.one(query)}
  end
end
