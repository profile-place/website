defmodule ProfilePlaceWeb.PageController do
  use ProfilePlaceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
