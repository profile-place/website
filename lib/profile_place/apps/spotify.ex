defmodule ProfilePlace.Apps.Spotify do
  alias ProfilePlace.Util

  def request(id) do
    tokens = Util.find_one("token", %{_id: id})

    tokens =
      if tokens.expires_in < :os.system_time(:millisecond),
        do: Map.put(tokens, :access_token, refresh(tokens.refresh_token, id)),
        else: tokens

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

  def refresh(token, lookup_id) do
    id = Application.get_env(:profile_place, :spotify_id)
    secret = Application.get_env(:profile_place, :spotify_secret)

    payload = %{
      grant_type: "refresh_token",
      refresh_token: token
    }

    %{status_code: 200, body: tokens} =
      HTTPoison.post!(
        "https://accounts.spotify.com/api/token",
        URI.encode_query(payload),
        [
          {"Authorization", "Basic " <> Base.encode64("#{id}:#{secret}")},
          {"Content-Type", "application/x-www-form-urlencoded"}
        ]
      )

    tokens = Util.decode_to_atoms(tokens)

    Mongo.update_one(:db, "token", %{_id: lookup_id}, %{
      "$set" => %{
        access_token: tokens.access_token,
        expires_in: :os.system_time(:millisecond) + tokens.expires_in * 1000
      }
    })

    tokens.access_token
  end
end
