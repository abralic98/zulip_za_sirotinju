defmodule Graphql.Schemas.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  use ZulipZaSirotinjuWeb.Auth.CustomMiddleware


  alias Graphql.Queries.{
    CurrentUser,
    HealthCheck,
    GetRooms,
    GetAccounts,
    GetMessagesByRoomId,
    GetUserAvatar,
    GetUserConversations,
    GetConversationRepliesByConversationId
  }

  alias Graphql.Subscriptions.{
    GetConversationsSubscription,
    GetConversationRepliesByConversationIdSubscription,
    PrivateNotificationsSubscription
  }

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
    DeleteMessage,
    UploadAvatar,
    UpdateUser,
    AccessProtectedRoom,
    CreateConversation,
    CreateConversationReply
  }

  alias Schemas.Message
  alias Schemas.Notification
  alias Schemas.Room
  alias Schemas.Conversation
  alias Schemas.ConversationReply

  # Enums
  import_types(Graphql.Types.Enums)

  import_types(Graphql.Types.Inputs.{
    CreateSessionInput,
    CreateAccountInput,
    CreateRoomInput,
    CreateMessageInput,
    CreateFileInput,
    UpdateProfileInput,
    CreateConversationReplyInput
  })

  import_types(SunnyDayWeb.API.Graphql.Scalars.DateTime)
  import_types(Graphql.Types.Objects.AccountType)
  import_types(Graphql.Types.Objects.CreateSessionType)
  import_types(Graphql.Types.Objects.RoomType)
  import_types(Graphql.Types.Objects.MessageType)
  import_types(Graphql.Types.Objects.NotificationType)
  import_types(Graphql.Types.Objects.FileType)
  import_types(Graphql.Types.Objects.ConversationType)
  import_types(Graphql.Types.Objects.ConversationReplyType)
  import_types(Graphql.Types.Objects.PrivateNotificationType)

  connection(node_type: :account)
  connection(node_type: :message)
  connection(node_type: :conversation_reply)

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

      %Schemas.ConversationReply{}, _ ->
        :conversation_reply

      _, _ ->
        nil
    end)
  end

  @desc "Get Messages By Room Id Socket"
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

    @desc "Get Replies By Conversation Id Socket"
    field :get_conversation_replies_by_conversation_id_socket, :conversation_reply do
      arg(:id, non_null(:id))

      config(fn args, _ ->
        {:ok, topic: "Conversation:#{args.id}"}
      end)

      trigger(:create_conversation_reply,
      topic: fn conversation_reply ->
        "ConversationReply: #{conversation_reply.id}"
      end
      )

      resolve(fn conversation_reply, _, _ ->
        response =
          Repo.get(ConversationReply, conversation_reply.id)
          |> Repo.preload(:account)
          |> Repo.preload(:conversation)

        {:ok, response}
      end)
    end

    @desc "Get Accounts Socket"
    field :get_accounts, list_of(:account) do
      config(fn _, _ ->
        {:ok, topic: "Accounts"}
      end)

      trigger(:update_account_status,
        topic: fn _ ->
          "Accounts"
        end
      )

      trigger(:update_profile,
        topic: fn _ ->
          "Accounts"
        end
      )

      resolve(&GetAccounts.resolve_subscription/3)
    end

    @desc "Get Public Notifications"
    field :notifications, :notification do
      config(fn _, _ ->
        {:ok, topic: "Notifications"}
      end)

      resolve(fn notification, _, _ ->
        response =
          Repo.get(Notification, notification.id)
          |> Repo.preload(:account)
          |> Repo.preload(:message)
          |> Repo.preload(:room)

        {:ok, response}
      end)
    end

    @desc "Get Private Notifications"
    field :private_notifications, :private_notification do
      arg(:id, non_null(:id))
      config(fn args, _ ->
        {:ok, topic: "PrivateNotifications: #{args.id}"}
      end)

      resolve(&PrivateNotificationsSubscription.resolve/3)
    end

    @desc "Get Rooms Socket"
    field :get_rooms_subscription, list_of(:room) do
      config(fn _, _ ->
        {:ok, topic: "Rooms"}
      end)

      trigger(:create_room,
        topic: fn _ ->
          "Rooms"
        end
      )

      resolve(fn _, _, _ ->
        response = Repo.all(Room)
        {:ok, response}
      end)
    end

    @desc "Get User Private Conversations Socket"
    field :get_conversations_subscription, list_of(:conversation) do
      config(fn _, _ ->
        {:ok, topic: "Conversations"}
      end)

      trigger(:create_conversation,
        topic: fn _ ->
          "Conversations"
        end
      )

      resolve(&GetConversationsSubscription.resolve/3)
    end

  end
  query do
    @desc "Health check"

    field :health_check, :boolean do
      resolve(&HealthCheck.resolve/3)
    end

    @desc "Get User"
    field :me, :account do
      resolve(&CurrentUser.call/3)
    end

    @desc "Get All Rooms"
    field :get_rooms, list_of(:room) do
      resolve(&GetRooms.resolve/3)
    end

    @desc "Get All Accounts"
    field :get_accounts, list_of(:account) do
      resolve(&GetAccounts.resolve/3)
    end

    @desc "Get User Avatar"
    field :get_user_avatar, :avatar do
      resolve(&GetUserAvatar.resolve/3)
    end

    @desc "Get User Avatar Id"
    field :get_user_avatar_id, :avatar do
      arg(:user_id, non_null(:id))
      resolve(&GetUserAvatar.resolve_other/3)
    end

    @desc "Get User Private Conversations"
    field :get_user_conversations, list_of(:conversation) do
      resolve(&GetUserConversations.resolve/3)
    end

    @desc "Paginated Messages in Room"
    connection field :get_messages_by_room_id, node_type: :message do
      arg(:room_id, :id)
      resolve(&GetMessagesByRoomId.resolve/3)
    end

    @desc "Paginated Private Messages in Conversation"
    connection field :get_conversation_replies_by_conversation_id, node_type: :conversation_reply do
      arg(:conversation_id, :id)
      resolve(&GetConversationRepliesByConversationId.resolve/3)
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

      resolve(fn
        %{type: :conversation_reply, id: local_id}, _ ->
          {:ok, Repo.get(Schemas.ConversationReply, local_id)}

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
    @desc "Register"
    field :create_account, :account do
      arg(:input, non_null(:create_account_input))
      resolve(&CreateAccount.resolve/3)
    end

    @desc "Update Account Status"
    field :update_account_status, :account do
      arg(:status, :account_status)
      resolve(&UpdateAccountStatus.resolve/3)
    end

    @desc "Create Session"
    field :create_session, :session do
      arg(:input, :create_session_input)
      resolve(&CreateSession.resolve/3)
    end

    @desc "Create Room"
    field :create_room, :room do
      arg(:input, :create_room_input)
      resolve(&CreateRoom.resolve/3)
    end

    @desc "Update Room"
    field :update_room, :room do
      arg(:id, :id)
      arg(:input, :create_room_input)
      resolve(&UpdateRoom.resolve/3)
    end

    @desc "Delete Room"
    field :delete_room, :room do
      arg(:id, :id)
      resolve(&DeleteRoom.resolve/2)
    end

    @desc "Create Message"
    field :create_message, :message do
      arg(:input, :create_message_input)
      resolve(&CreateMessage.resolve/3)
    end

    @desc "Update Message"
    field :update_message, :message do
      arg(:id, :id)
      arg(:input, :create_message_input)
      resolve(&UpdateMessage.resolve/3)
    end

    @desc "Delete Message"
    field :delete_message, :message do
      arg(:id, :id)
      resolve(&DeleteMessage.resolve/2)
    end

    @desc "Upload Image"
    field :upload_avatar, :avatar do
      arg(:avatar, non_null(:create_file_input))
      resolve(&UploadAvatar.resolve/3)
    end

    @desc "Update Profile Info"
    field :update_profile, :account do
      arg(:input, :update_profile_input)
      resolve(&UpdateUser.resolve/3)
    end

    @desc "Enter Protected Room"
    field :access_protected_room, :boolean do
      arg(:room_id, non_null(:id))
      arg(:password, non_null(:string))
      resolve(&AccessProtectedRoom.resolve/3)
    end

    @desc "Create Private Conversation"
    field :create_conversation, :conversation do
      arg(:user_two, non_null(:id))
      resolve(&CreateConversation.resolve/3)
    end

    @desc "Send Private Message"
    field :create_conversation_reply, :conversation_reply do
      arg(:input, :create_conversation_reply_input)
      resolve(&CreateConversationReply.resolve/3)
    end
  end
end
