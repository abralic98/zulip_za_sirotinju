defmodule Graphql.Queries.GetUserAvatar do
  import Ecto.Query
  alias ZulipZaSirotinju.Repo
  alias Schemas.Avatar

  def resolve(_, _, %{context: %{current_user: current_user}}) do
    query =
      from(a in Avatar,
        where: a.account_id == ^current_user.id,
        order_by: [desc: a.inserted_at],
        limit: 1
      )

    case Repo.one(query) do
      nil ->
        {:error, "Avatar does not exist"}

      avatar ->
        {:ok, avatar}
    end
  end

  def resolve_other(_, %{user_id: user_id}, _) do
    query =
      from(a in Avatar,
        where: a.account_id == ^user_id,
        order_by: [desc: a.inserted_at],
        limit: 1
      )

    case Repo.one(query) do
      nil ->
        {:error, "Avatar does not exist"}

      avatar ->
        {:ok, avatar}
    end
  end
end
