defmodule ProfilePlaceWeb.AccountController do
  use ProfilePlaceWeb, :controller

  alias ProfilePlace.{Token, User}

  @email_regex ~r([\w.!#$%&'*+-/=?^`{|}~]{1,64}@[a-z0-9-]{1,255}.[a-z-]{1,64})

  def signup(conn, %{"email" => email, "pass" => pass}) do
    email = email |> String.downcase(:ascii)
    password = pass |> Argon2.Base.hash_password(Argon2.gen_salt())

    cond do
      !Regex.match?(@email_regex, email) ->
        send_resp(conn, 400, "invalid email address")

      Mongo.find_one(:db, "user", %{email: email}) ->
        send_resp(conn, 400, "email address in use")

      true ->
        Mongo.insert_one(
          :db,
          "user",
          # gotta use Map.from_struct/1 here since structs don't have the Enumerable protocol implemented kek
          Map.from_struct(%User{
            _id: Snowflake.next_id() |> elem(1),
            data: %{},
            email: email,
            password: password,
            connections: [],
            max_slugs: 1
          })
        )

        send_resp(conn, 200, "yeet")
    end
  end

  def login(conn, %{"email" => email, "pass" => pass}) do
    email = email |> String.downcase(:ascii)

    user = ProfilePlace.Util.find_one("user", %{email: email})

    cond do
      !user ->
        # this shouldn't be 400 but ok
        send_resp(conn, 400, Jason.encode!(%{message: "email doesn't exist"}))

      !Argon2.verify_pass(pass, user.password) ->
        send_resp(conn, 401, "Wrong password")

      true ->
        token = %Token{
          _id: ProfilePlace.gen_secret(),
          owner: user._id,
          type: 0,
          timestamp: :os.system_time(:millisecond) - 1_577_836_800_000
        }

        encoded = Token.encode(token)
        Redix.command(:redis, ["SET", encoded, token.type])

        conn
        |> put_resp_cookie("token", encoded)
        |> send_resp(200, "yeet")
    end
  end
end
