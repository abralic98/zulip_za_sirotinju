defmodule Graphql.Schemas.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  use ZulipZaSirotinjuWeb.Auth.CustomMiddleware

  alias Graphql.Queries.{CurrentUser, HealthCheck}
  alias Graphql.Mutations.{CreateSession, CreateAccount}

  import_types(Graphql.Types.Inputs.{CreateSessionInput, CreateAccountInput})
  import_types(Graphql.Types.Objects.AccountType)
  import_types(Graphql.Types.Objects.CreateSessionType)

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

  end
end
