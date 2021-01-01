defmodule ProfilePlaceWeb.SpotifyController do
  use ProfilePlaceWeb, :controller

  alias ProfilePlace.Util

  plug :put_view, ProfilePlaceWeb.PageView

  def init(conn, _params) do
    id = Application.get_env(:profile_place, :spotify_id)

    redirect = Application.get_env(:profile_place, :spotify_redirect) |> URI.encode()

    redirect(conn,
      # god i hate how this gets linted
      external:
        "https://accounts.spotify.com/authorize?response_type=code&scope=user-read-playback-state&client_id=#{
          id
        }&redirect_uri=#{redirect}"
    )
  end

  def callback(conn, %{"code" => code}) do
    id = Application.get_env(:profile_place, :spotify_id)
    secret = Application.get_env(:profile_place, :spotify_secret)

    redirect = Application.get_env(:profile_place, :spotify_redirect) |> URI.encode()

    payload = %{
      grant_type: "authorization_code",
      code: code,
      redirect_uri: redirect
    }

    %{status_code: 200, body: tokens} =
      HTTPoison.post!(
        "https://accounts.spotify.com/api/token",
        ProfilePlace.urlencode(payload),
        [
          {"Authorization", "Basic " <> Base.encode64("#{id}:#{secret}")},
          {"Content-Type", "application/x-www-form-urlencoded"}
        ]
      )

    tokens = Util.decode_to_atoms(tokens)

    %{status_code: 200, body: user} =
      HTTPoison.get!("https://api.spotify.com/v1/me", [
        {"Authorization", "Bearer #{tokens.access_token}"}
      ])

    user = Util.decode_to_atoms(user)

    Util.save_tokens(tokens, conn.assigns.token_owner, "spotify", user.id)
    Util.insert_into_db(user, conn.assigns.token_owner, "spotify", :id)

    render(conn, "linked.html", %{app: "Spotify", name: user.display_name})
  end
end
