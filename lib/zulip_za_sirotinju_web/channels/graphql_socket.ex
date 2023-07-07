defmodule ZulipZaSirotinju.GraphqlSocket do
  use Phoenix.Socket
  use Joken.Config, default_signer: :pem_rs256

  use Absinthe.Phoenix.Socket,
    schema: Graphql.Schemas.Schema

  alias ZulipZaSirotinju.Repo
  alias Absinthe.Phoenix.Socket, as: AbsintheSocket
  alias Schemas.Account

  def connect(params, socket) do
    {:ok, kurcinaa} = extract_token(params)
    extracted_token = extract_token2(kurcinaa)

    token =
      case extracted_token do
        {:ok, token} -> token
        _ -> nil
      end

    current_user_joken =
      Services.Token.verify_and_validate(token, Services.Token.Signer.generate())

    account =
      case current_user_joken do
        {:ok, acc} -> acc
        _ -> nil
      end

    account_id = account["account_id"]

    current_account = current_user(account_id)

    without_ok =
      case current_account do
        {:ok, curr_acc} -> curr_acc
        _ -> nil
      end

    socket =
      Absinthe.Phoenix.Socket.put_options(socket,
        context: %{
          current_user: without_ok
        }
      )

    {:ok, socket}
  end

  defp extract_token(params) do
    token = Map.get(params, "Authorization")
    {:ok, token}
  end

  defp extract_token2(params) do
    token = String.replace_prefix(params, "Bearer ", "")
    {:ok, token}
  end

  defp current_user(id) do
    {:ok, Repo.get(Account, id)}
  end

  def id(_socket), do: nil
end
