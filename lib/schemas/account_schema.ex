defmodule Schemas.Account do
  alias Schemas.Avatar
  use Ecto.Schema

  import Bcrypt, only: [hash_pwd_salt: 1]
  import Ecto.Changeset

  @changeset ~w(email password first_name last_name username active status)a
  @changeset_update ~w(email first_name last_name username)a

  schema "accounts" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_digest, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:username, :string)
    field(:active, :boolean, default: true)
    field :status, Ecto.Enum, values: [:online, :offline, :away, :busy]
    has_many(:avatar, Avatar)

    timestamps()
  end

  def changeset(account, args \\ %{}) do
    account
    |> cast(args, @changeset)
    |> validate_email()
    |> validate_password()
    |> put_pass_digest
  end

  def changeset_update_account(account, args \\ %{}) do
    account
    |> cast(args, @changeset)
  end

  defp validate_email(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        changeset
        |> validate_length(:email, min: 6, max: 255)
        |> validate_format(:email, ~r/.+@.+\..+/)
        |> unique_constraint(:email)

      _ ->
        changeset
    end
  end

  defp validate_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        validate_length(changeset, :password, min: 8)

      _ ->
        changeset
    end
  end

  defp put_pass_digest(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: raw_passwd}} ->
        put_change(changeset, :password_digest, hash_pwd_salt(raw_passwd))

      changeset ->
        changeset
    end
  end
end
