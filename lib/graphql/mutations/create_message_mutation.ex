defmodule Graphql.Mutations.CreateMessage do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Message

  def resolve(_, args, %{context: %{current_user: current_user}}) do
    modified = Map.put(args, :account_id, Map.get(current_user, :id))
    IO.inspect(modified)
    %Message{}
    |> Message.changeset(modified)
    |> Repo.insert()
  end
end
