defmodule ProfilePlace.App do
  alias ProfilePlace.Util

  @doc """
  Gets the app name from a connection _id (for example discord:123456789 would return "discord")
  """
  @spec get_app_name(String.t()) :: String.t()
  def get_app_name(str), do: String.split(str, ":") |> List.first()

  def test_req do
    tokens = Util.find_one("token", %{_owner: 124_200_217_045_106_688})

    Task.async(fn ->
      %{status_code: 200, body: data} =
        HTTPoison.get!(
          "https://api.spotify.com/v1/me/player/currently-playing",
          [
            {"Authorization", "Bearer " <> tokens.access_token}
          ]
        )

      data = Util.decode_to_atoms(data)

      data.item.name
    end)
  end
end
