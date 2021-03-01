defmodule ProfilePlace.App do
  alias ProfilePlace.Apps

  @stylized_map %{
    "discord" => "Discord",
    "spotify" => "Spotify"
  }

  @doc """
  Gets the app name from a connection `_id` (for example `"discord:123456789"` would return "discord")
  """
  @spec get_name(String.t()) :: String.t()
  def get_name(str), do: String.split(str, ":") |> List.first()

  @doc """
  Packages the data into a map that the frontend can use
  """
  @spec package(String.t(), String.t()) :: map()
  def package(id, data) do
    %{
      _id: id,
      desc: data
    }
  end

  def stylized(id), do: Map.get(@stylized_map, get_name(id))

  def test_req(id), do: magic(id, :request)

  # Oh boy, magic function. well, it isnt *too* much magic, but magic regardless. It takes the id (`"app_name:identifier"`) and
  # a method you want to call on the app (located in `/apps`), transforms the `app_name` to reference the module, and calls
  # `apply/3`. there is probably a better way to do all this, but I'm tired and want to sleep
  defp magic(id, method) do
    id
    |> get_name()
    |> String.capitalize()
    |> (fn x -> [Apps, x] end).()
    |> Module.concat()
    |> apply(method, [id])
  end
end
