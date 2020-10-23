defmodule ProfilePlaceWeb.ProfileController do
  use ProfilePlaceWeb, :controller

  plug :put_view, ProfilePlaceWeb.PageView

  def show(conn, %{"id" => id}) do
    # we can later do regex magic here to figure out if we are dealing with an id or slug
    id = String.to_integer(id)

    case ProfilePlace.Util.find_one("user", %{_id: id}) do
      nil ->
        send_resp(conn, 404, "not found lul")

      user ->
        connections = ProfilePlace.Util.find("connection", %{_owner: user._id})
        render(conn, "profile.html", %{user: user, connections: connections})
    end
  end
end
