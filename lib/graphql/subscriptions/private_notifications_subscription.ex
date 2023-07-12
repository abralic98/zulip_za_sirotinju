defmodule Graphql.Subscriptions.PrivateNotificationsSubscription do
  alias ZulipZaSirotinju.Repo
  alias Schemas.PrivateNotification

  def resolve(private_notification, _, _) do
    response =
      Repo.get(PrivateNotification, private_notification.id)
      |> Repo.preload(:account)
      |> Repo.preload(:conversation_reply)
      |> Repo.preload(:conversation)

    {:ok, response}
  end
end
