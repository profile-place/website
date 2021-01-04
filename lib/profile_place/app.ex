defmodule ProfilePlace.App do
  alias ProfilePlace.Apps

  @doc """
  Gets the app name from a connection _id (for example discord:123456789 would return "discord")
  """
  @spec get_name(String.t()) :: atom()
  def get_name(str), do: String.split(str, ":") |> List.first() |> String.to_atom()

  def test_req(<<"spotify", _::binary>> = id) do
    Apps.Spotify.request(id)
  end

  def test_req(<<"discord", _::binary>> = id) do
    Apps.Discord.request(id)
  end
end
