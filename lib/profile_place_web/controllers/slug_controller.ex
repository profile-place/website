defmodule ProfilePlaceWeb.SlugController do
  use ProfilePlaceWeb, :controller

  def add(conn, _params) do
    send_resp(conn, 200, "ok")
  end
end
