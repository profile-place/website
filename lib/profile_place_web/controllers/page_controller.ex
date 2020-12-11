defmodule ProfilePlaceWeb.PageController do
  use ProfilePlaceWeb, :controller

  def index(conn, _params), do: render(conn, "index.html")

  def login(conn, _params), do: render(conn, "login.html")

  def join(conn, _params), do: render(conn, "join.html")

  def slugmanagementpage(conn, _params), do: render(conn, "slugmanagementpage.html")
end
