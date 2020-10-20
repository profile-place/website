defmodule ProfilePlaceWeb.SpotifyController do
  use ProfilePlaceWeb, :controller

  plug :put_view, ProfilePlaceWeb.PageView

  def init(conn, _params) do
    id = Application.get_env(:profile_place, :spotify_id)

    redirect = Application.get_env(:profile_place, :spotify_redirect) |> URI.encode()

    redirect(conn,
      external:
        "https://accounts.spotify.com/authorize?response_type=code&client_id=#{id}&redirect_uri=#{
          redirect
        }"
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

    tokens = Jason.decode!(tokens)

    %{status_code: 200, body: user} =
      HTTPoison.get!("https://api.spotify.com/v1/me", [
        {"Authorization", "Bearer #{tokens["access_token"]}"}
      ])

    user = Jason.decode!(user)

    user =
      Map.merge(user, %{
        "_owner" => conn.assigns.token_owner,
        "_id" => "spotify:#{user["id"]}"
      })

    case Mongo.find_one(:db, "connection", %{_id: user["_id"]}) do
      nil -> Mongo.insert_one(:db, "connection", user)
      _ -> Mongo.find_one_and_update(:db, "connection", %{_id: user["_id"]}, %{"$set" => user})
    end

    render(conn, "linked.html", %{app: "Spotify", name: user["display_name"]})
  end
end
