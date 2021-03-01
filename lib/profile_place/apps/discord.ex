defmodule ProfilePlace.Apps.Discord do
  alias ProfilePlace.{App, Util}

  def request(id) do
    tokens = Util.find_one("token", %{_id: id})

    tokens =
      if tokens.expires_in < :os.system_time(:millisecond),
        do: Map.put(tokens, :access_token, refresh(tokens.refresh_token, id)),
        else: tokens

    Task.async(fn ->
      %{status_code: 200, body: data} =
        HTTPoison.get!(
          "https://discord.com/api/v8/users/@me",
          [
            {"Authorization", "Bearer " <> tokens.access_token}
          ]
        )

      data = Util.decode_to_atoms(data)

      App.package(id, "#{data.username}##{data.discriminator}")
    end)
  end

  def refresh(token, lookup_id) do
    payload = %{
      client_id: Application.get_env(:profile_place, :discord_id),
      client_secret: Application.get_env(:profile_place, :discord_secret),
      grant_type: "refresh_token",
      refresh_token: token,
      redirect_uri: Application.get_env(:profile_place, :discord_redirect),
      scope: "identify connections"
    }

    %{status_code: 200, body: tokens} =
      HTTPoison.post!(
        "https://discord.com/api/oauth2/token",
        URI.encode_query(payload),
        [
          {"Content-Type", "application/x-www-form-urlencoded"}
        ]
      )

    tokens = Util.decode_to_atoms(tokens)

    Mongo.find_one_and_update(:db, "token", %{_id: lookup_id}, %{
      "$set" => %{
        access_token: tokens.access_token,
        expires_in: :os.system_time(:millisecond) + tokens.expires_in * 1000,
        refresh_token: tokens.refresh_token
      }
    })

    tokens.access_token
  end
end
