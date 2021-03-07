defmodule ProfilePlaceWeb.ProfileControllerLive do
  use ProfilePlaceWeb, :controller
  use Phoenix.LiveView

  alias ProfilePlace.{Slug, Util}

  plug :put_view, ProfilePlaceWeb.PageView

  def show(conn, %{"id" => id}) do
    if Slug.is_slug?(id) do
      # we are dealing with a slug
      case Util.find_one("slug", %{_id: id}) do
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
    case Util.find_one("user", %{_id: id}) do
      nil ->
        send_resp(conn, 404, "not found lul")

      user ->
        connections = ProfilePlace.Util.find("connection", %{_owner: user._id}) || []

        connections =
          connections
          |> Enum.map(fn conn -> ProfilePlace.App.test_req(conn._id) end)
          |> Task.await_many()

        live_render(conn, "profile.html", %{user: user, connections: connections})
    end
  end
end
