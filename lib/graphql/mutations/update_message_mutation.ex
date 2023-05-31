
defmodule Graphql.Mutations.UpdateMessage do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Message

  def resolve(_, %{id: id, input: update_message_params}, _context) do
    Repo.get(Message, id)
    |> Message.changeset(update_message_params)
    |> Repo.update()
  end
end
