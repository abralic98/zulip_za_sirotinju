defmodule Graphql.Mutations.UploadAvatar do
  alias Schemas.Avatar
  alias ZulipZaSirotinju.Repo

  def resolve(_, %{avatar: create_file_input}, %{context: %{current_user: current_user}}) do

    IO.inspect(create_file_input)
    modified = Map.put(create_file_input, :account_id, Map.get(current_user, :id))
    IO.inspect(modified)
    {:ok, avatar} =
      %Avatar{}
      |> Avatar.changeset(modified)
      |> Repo.insert()
  end
end
