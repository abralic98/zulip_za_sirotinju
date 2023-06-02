defmodule Graphql.Schemas.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  use ZulipZaSirotinjuWeb.Auth.CustomMiddleware

  alias Graphql.Queries.{CurrentUser, HealthCheck, GetRooms, GetAccounts, GetMessagesByRoomId}
  alias ZulipZaSirotinju.Repo

  alias Graphql.Mutations.{
    CreateSession,
    CreateAccount,
    CreateRoom,
    CreateMessage,
    UpdateRoom,
    UpdateMessage,
    DeleteRoom,
    DeleteMessage
  }

  alias Schemas.Message

  # alias Graphql.Topics

  import_types(Graphql.Types.Inputs.{
    CreateSessionInput,
    CreateAccountInput,
    CreateRoomInput,
    CreateMessageInput
  })

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

  subscription do
    field :get_messages_by_room_id_socket, list_of(:message) do
      arg(:id, non_null(:string))
      arg(:page, :string)
      arg(:limit, :string)

      config(fn args, _ ->
        {:ok, topic: "Room:#{args.id}"}
      end)

      trigger(:create_message,
        topic: fn message ->
          "Message: #{message.id}"
        end
      )

      resolve(fn message, _, _ ->
        response =
          Repo.get(Message, message.id)
          |> Repo.preload(:account)

        {:ok, response}
      end)
    end
  end

  query do
    node field do
      resolve(fn
        %{type: :account, id: local_id}, _ ->
          {:ok, Repo.get(Schemas.Account, local_id)}

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

    field :delete_room, :room do
      arg(:id, :id)
      resolve(&DeleteRoom.resolve/2)
    end

    @desc "Create Message"
    field :create_message, :message do
      arg(:input, :create_message_input)
      resolve(&CreateMessage.resolve/3)
    end

    field :update_message, :message do
      arg(:id, :id)
      arg(:input, :create_message_input)
      resolve(&UpdateMessage.resolve/3)
    end

    field :delete_message, :message do
      arg(:id, :id)
      resolve(&DeleteMessage.resolve/2)
    end
  end
end
