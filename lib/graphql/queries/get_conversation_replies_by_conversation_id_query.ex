defmodule Graphql.Queries.GetConversationRepliesByConversationId do
  alias ZulipZaSirotinju.Repo
  alias Schemas.ConversationReply
  alias Schemas.Account
  import Ecto.Query
  alias Absinthe.Relay.Connection

  def resolve(_, args, _) do
    ConversationReply
    |> where([cr], cr.conversation_id == ^args.conversation_id)
    |> order_by([p], desc: p.inserted_at)
    |> preload(:account)
    |> Connection.from_query(
      &Repo.all/1,
      default_pagination(args)
    )
  end

  defp default_pagination(%{:last => _} = data), do: data

  defp default_pagination(data), do: Map.put_new(data, :first, 1000)
end
