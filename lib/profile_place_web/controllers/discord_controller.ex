defmodule ProfilePlaceWeb.DiscordController do
  use ProfilePlaceWeb, :controller

  plug :put_view, ProfilePlaceWeb.PageView

  def init(conn, _params) do
    id = Application.get_env(:profile_place, :discord_id) |> URI.encode()
    redirect = Application.get_env(:profile_place, :discord_redirect) |> URI.encode()

    redirect(conn,
      external:
        "https://discord.com/api/oauth2/authorize?client_id=#{id}&redirect_uri=#{redirect}&response_type=code&scope=identify"
    )
  end

  def callback(conn, %{"code" => code}) do
    payload = %{
      client_id: Application.get_env(:profile_place, :discord_id),
      client_secret: Application.get_env(:profile_place, :discord_secret),
      grant_type: "authorization_code",
      code: code,
      redirect_uri: Application.get_env(:profile_place, :discord_redirect),
      scope: "identify connections"
    }

    # bang bad, handle errors properly pls thx
    %{status_code: 200, body: tokens} =
      HTTPoison.post!("https://discord.com/api/oauth2/token", ProfilePlace.urlencode(payload), [
        {"Content-Type", "application/x-www-form-urlencoded"}
      ])

    # TODO: tokens should be stored somewhere
    tokens = Jason.decode!(tokens)

    %{status_code: 200, body: user} =
      HTTPoison.get!("https://discord.com/api/users/@me", [
        {"Authorization", "Bearer #{tokens["access_token"]}"}
      ])

    # lmao this is ugly pls format later
    user = Jason.decode!(user)

    user =
      Map.merge(user, %{
        "_owner" => conn.assigns.token_owner,
        "_id" => "discord:#{user["id"]}"
      })

    case Mongo.find_one(:db, "connection", %{_id: user["_id"]}) do
      nil -> Mongo.insert_one(:db, "connection", user)
      _ -> Mongo.find_one_and_update(:db, "connection", %{_id: user["_id"]}, %{"$set" => user})
    end

    # TODO: this should be a redirect instead
    render(conn, "linked.html", %{app: "Discord", name: user["username"]})
  end
end
