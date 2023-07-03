defmodule Graphql.Schemas.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  use ZulipZaSirotinjuWeb.Auth.CustomMiddleware

  alias Graphql.Queries.{CurrentUser, HealthCheck, GetRooms, GetAccounts, GetMessagesByRoomId}
  alias ZulipZaSirotinju.Repo

  alias Graphql.Mutations.{
    CreateSession,
    CreateAccount,
    UpdateAccountStatus,
    CreateRoom,
    CreateMessage,
    UpdateRoom,
    UpdateMessage,
    DeleteRoom,
    DeleteMessage
  }

  alias Schemas.Message
  alias Schemas.Account
  alias Schemas.Notification
  alias Schemas.Room

  # Enums
  import_types(Graphql.Types.Enums)

  import_types(Graphql.Types.Inputs.{
    CreateSessionInput,
    CreateAccountInput,
    CreateRoomInput,
    CreateMessageInput
  })

  import_types(SunnyDayWeb.API.Graphql.Scalars.DateTime)
  import_types(Graphql.Types.Objects.AccountType)
  import_types(Graphql.Types.Objects.CreateSessionType)
  import_types(Graphql.Types.Objects.RoomType)
  import_types(Graphql.Types.Objects.MessageType)
  import_types(Graphql.Types.Objects.NotificationType)

  connection(node_type: :account)
  connection(node_type: :message)

  node interface do
    resolve_type(fn
      %Schemas.Account{}, _ ->
        :account

      _, _ ->
        nil

      %Schemas.Message{}, _ ->
        :message

      _, _ ->
        nil
    end)
  end

  subscription do
    field :get_messages_by_room_id_socket, :message do
      arg(:id, non_null(:id))

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
          |> Repo.preload(:room)

        {:ok, response}
      end)
    end

    field :get_accounts, list_of(:account) do
      config(fn _, _ ->
        {:ok, topic: "Accounts"}
      end)

      trigger(:update_account_status,
        topic: fn account ->
          "Accounts"
        end
      )

      resolve(&GetAccounts.resolve_subscription/3)
    end

    field :notifications, :notification do
      config(fn _, _ ->
        {:ok, topic: "Notifications"}
      end)

      #zasto voo radi bez trigera pitaj boga vjerovatno zbog  createmessagemutation pogleda
      # trigger(:create_message,
      #   topic: fn notification ->
      #     "Notifications"
      #   end
      # )

      resolve(fn notification, _, _ ->
        response =
          Repo.get(Notification, notification.id)
          |> Repo.preload(:account)
          |> Repo.preload(:message)
          |> Repo.preload(:room)

        IO.inspect(response, label: "RESPONSE_________________________________________________________________________-----------------------------------")
        {:ok, response}
      end)
    end

    field :get_rooms_subscription, list_of(:room) do
      config(fn _, _ ->
        {:ok, topic: "Rooms"}
      end)

      trigger(:create_room,
        topic: fn room ->
          IO.inspect(room, label: "trigger")
          "Rooms"
        end
      )

      resolve(fn room, _, _ ->
        IO.inspect(room, label: "RESOLVe")
        response = Repo.all(Room)
        {:ok, response}
      end)
    end
  end

  query do
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

    connection field :get_messages_by_room_id, node_type: :message do
      arg(:room_id, :id)
      resolve(&GetMessagesByRoomId.resolve/3)
    end

    node field do
      resolve(fn
        %{type: :message, id: local_id}, _ ->
          {:ok, Repo.get(Schemas.Message, local_id)}

        _, _ ->
          {:error, "Unknown node"}

        %{type: :account, id: local_id}, _ ->
          {:ok, Repo.get(Schemas.Account, local_id)}

        _, _ ->
          {:error, "Unknown node"}
      end)
    end
  end

  mutation do
    field :create_account, :account do
      arg(:input, non_null(:create_account_input))
      resolve(&CreateAccount.resolve/3)
    end

    field :update_account_status, :account do
      arg(:status, :account_status)
      resolve(&UpdateAccountStatus.resolve/3)
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
