defmodule ProfilePlaceWeb.Plugs.AuthenticateCookie do
  import Plug.Conn
  import Phoenix.Controller

  def init(_params) do
  end

  def call(conn, _params) do
    owner = ProfilePlace.Token.get_owner(conn.cookies["token"])

    case Mongo.find_one(:db, "user", %{_id: owner}) do
      nil -> redirect(conn, to: "/login") |> halt()
      _ -> assign(conn, :token_owner, owner)
    end
  end
end
