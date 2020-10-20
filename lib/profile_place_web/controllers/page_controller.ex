defmodule ProfilePlaceWeb.PageController do
  use ProfilePlaceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def profile(conn, _params) do
    # conn = fetch_cookies(conn)
    render(conn, "profile.html", user: ProfilePlace.Token.get_owner(conn.cookies["token"]))
  end
end
