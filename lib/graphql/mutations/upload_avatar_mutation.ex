defmodule Graphql.Mutations.UploadAvatar do
  alias Schemas.Avatar
  alias ZulipZaSirotinju.Repo

  def resolve(_, %{avatar: create_file_input}, %{context: %{current_user: current_user}}) do
    modified = Map.put(create_file_input, :account_id, Map.get(current_user, :id))

    case Repo.get_by(Avatar, file_name: create_file_input.file_name) do
      nil ->
        {:ok, avatar} =
          %Avatar{}
          |> Avatar.changeset(modified)
          |> Repo.insert()

      existing_avatar ->
        {:error, "Avatar Exists"}
    end
  end
end
