
defmodule Graphql.Mutations.DeleteMessage do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Message

  def resolve(%{id: id}, _info) do

    case Repo.get(Message, id) do
      nil ->
        {:error, "Message does not exist"}

      message ->
        Repo.delete!(message)
        {:ok, message}
    end
  end
end
