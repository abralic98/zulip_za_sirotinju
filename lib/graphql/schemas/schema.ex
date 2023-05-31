defmodule Graphql.Schemas.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  use ZulipZaSirotinjuWeb.Auth.CustomMiddleware

  alias Graphql.Queries.{CurrentUser, HealthCheck, GetRooms, GetAccounts, GetMessagesByRoomId}
  alias Graphql.Mutations.{CreateSession, CreateAccount, CreateRoom, CreateMessage, UpdateRoom}

  import_types(Graphql.Types.Inputs.{CreateSessionInput, CreateAccountInput, CreateRoomInput})
  import_types(Graphql.Types.Objects.AccountType)
  import_types(Graphql.Types.Objects.CreateSessionType)
  import_types(Graphql.Types.Objects.RoomType)
  import_types(Graphql.Types.Objects.MessageType)

  connection(node_type: :account)

  node interface do
    resolve_type(fn
      %Schemas.Account{}, _ ->
        :account

      _, _ ->
        nil
    end)
  end

  query do
    node field do
      resolve(fn
        %{type: :account, id: local_id}, _ ->
          {:ok, ZulipZaSirotinju.Repo.get(Schemas.Account, local_id)}

        _, _ ->
          {:error, "Unknown node"}
      end)
    end

    @desc "Health check"

    field :health_check, :boolean do
      resolve(&HealthCheck.resolve/3)
    end

    field :me, :account do
      resolve(&CurrentUser.call/3)
    end

    field :get_rooms, list_of(:room) do
      resolve(&GetRooms.resolve/3)
    end

    field :get_accounts, list_of(:account) do
      resolve(&GetAccounts.resolve/3)
    end

    field :get_messages_by_room_id, list_of(:message) do
      arg(:room_id, :id)
      resolve(&GetMessagesByRoomId.resolve/3)
    end

  end

  mutation do
    field :create_account, :account do
      arg(:input, :create_account_input)
      resolve(&CreateAccount.resolve/3)
    end

    field :create_session, :session do
      arg(:input, :create_session_input)
      resolve(&CreateSession.resolve/3)
    end

    field :create_room, :room do
      arg(:input, :create_room_input)
      resolve(&CreateRoom.resolve/3)
    end

    field :update_room, :room do
      arg(:id, :id)
      arg(:input, :create_room_input)
      resolve(&UpdateRoom.resolve/3)
    end

    field :create_message, :message do
      arg(:text, non_null(:string))
      arg(:room_id, non_null(:string))
      resolve(&CreateMessage.resolve/3)
    end

  end
end
