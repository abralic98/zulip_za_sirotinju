defmodule SunnyDayWeb.API.Graphql.Scalars.DateTime do
  use Absinthe.Schema.Notation

  scalar :datetime, description: "ISO8601 datetime" do
    serialize(fn time ->
      case time do
        %DateTime{} -> DateTime.to_iso8601(time)
        _ -> DateTime.to_iso8601(DateTime.from_naive!(time, "Etc/UTC"))
      end
    end)

    parse(fn
      %Absinthe.Blueprint.Input.Null{} ->
        {:ok, nil}

      arg ->
        case DateTime.from_iso8601(arg.value) do
          {:ok, dt, _} -> {:ok, dt}
          {:error, _msg} -> {:error, "DateTime parsing error"}
        end
    end)
  end
end
