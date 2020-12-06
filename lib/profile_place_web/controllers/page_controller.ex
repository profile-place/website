defmodule ProfilePlaceWeb.PageController do
  use ProfilePlaceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def join(conn, _params) do
    render(conn, "join.html")
  end
end
