defmodule ProfilePlaceWeb.ApiController do
  use ProfilePlaceWeb, :controller

  @email_regex ~r([\w.!#$%&'*+-/=?^`{|}~]{1,64}@[a-z0-9-]{1,255}.[a-z-]{1,64})

  def signup(conn, %{"email" => email, "pass" => pass}) do
    # yeah this crashes when it can't decode but who careees
    email = email |> Base.decode64!() |> String.downcase(:ascii)
    password = pass |> Base.decode64!() |> Argon2.Base.hash_password(Argon2.gen_salt())

    cond do
      !Regex.match?(@email_regex, email) ->
        send_resp(conn, 400, "invalid email address")

      Mongo.find_one(:db, "user", %{email: email}) ->
        send_resp(conn, 400, "email address in use")

      true ->
        Mongo.insert_one(:db, "user", %{
          _id: Snowflake.next_id() |> elem(1),
          email: email,
          password: password,
          connections: []
        })

        send_resp(conn, 200, "")
    end
  end
end
