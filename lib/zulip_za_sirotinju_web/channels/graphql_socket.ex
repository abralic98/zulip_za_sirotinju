defmodule ZulipZaSirotinju.GraphqlSocket do
  use Phoenix.Socket
  use Joken.Config, default_signer: :pem_rs256

  use Absinthe.Phoenix.Socket,
    schema: Graphql.Schemas.Schema

  alias ZulipZaSirotinju.Repo
  alias Absinthe.Phoenix.Socket, as: AbsintheSocket
  alias Schemas.Account

  def connect(params, socket) do
    {:ok, kurcinaa} = extract_token2(params)
    kita = extract_token(kurcinaa)

    kurac11 =
      case kita do
        {:ok, token} -> token
        _ -> nil
      end

    claims = Services.Token.verify_and_validate(kurac11, Services.Token.Signer.generate())

    current_user = current_user(params)

    socket =
      Absinthe.Phoenix.Socket.put_options(socket,
        context: %{
          current_user: current_user
        }
      )

    {:ok, socket}
  end

  defp extract_token(params) do
    # IO.puts("JEL USLO")
    # IO.inspect(params)
    token = String.replace_prefix(params, "Bearer ", "")
    # IO.puts("JEL PROSLO")
    # IO.inspect(token)
    {:ok, token}
  end

  defp extract_token2(params) do
    token = Map.get(params, "Authorization")
    {:ok, token}
  end

  defp current_user(id) do
    Repo.get(Account, 1)
  end

  def id(_socket), do: nil
end
