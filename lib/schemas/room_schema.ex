defmodule Schemas.Room do
  use Ecto.Schema

  import Ecto.Changeset
  alias Schemas.Message

  @changeset ~w(name password)a

  schema "rooms" do
    field :name, :string
    field :password, :string
    has_many :messages, Message
    timestamps()
  end

  def changeset(room, args \\ %{}) do
    room
    |> cast(args, @changeset)
    |> validate_name()
  end

  defp validate_name(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        changeset
        |> validate_length(:name, min: 3, max: 30)
        |> unique_constraint(:name)

      _ ->
        changeset
    end
  end
end
