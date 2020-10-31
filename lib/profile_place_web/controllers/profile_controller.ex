defmodule ProfilePlaceWeb.ProfileController do
  use ProfilePlaceWeb, :controller

  plug :put_view, ProfilePlaceWeb.PageView

  def show(conn, %{"id" => id}) do
    if ProfilePlace.Util.is_slug?(id) do
      # we are dealing with a slug
      case ProfilePlace.Util.find_one("slug", %{_id: id}) do
        nil ->
          send_resp(conn, 404, "not found lul")

        slug ->
          proceed_with_id(conn, slug.owner)
      end
    else
      # we are dealing with an id
      proceed_with_id(conn, String.to_integer(id))
    end
  end

  defp proceed_with_id(conn, id) do
    case ProfilePlace.Util.find_one("user", %{_id: id}) do
      nil ->
        send_resp(conn, 404, "not found lul")

      user ->
        connections = ProfilePlace.Util.find("connection", %{_owner: user._id})
        render(conn, "profile.html", %{user: user, connections: connections})
    end
  end
end
