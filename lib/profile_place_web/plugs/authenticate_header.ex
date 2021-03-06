defmodule ProfilePlaceWeb.Plugs.AuthenticateHeader do
  import Plug.Conn
  import Phoenix.Controller

  def init(_params) do
  end

  def call(conn, _params) do
    token = get_req_header(conn, "authorization") |> List.first()

    case Redix.command!(:redis, ["EXISTS", token]) do
      1 ->
        # we can pattern match on this to avoid a db call if its nil (this applies to cookie auth too)
        owner = ProfilePlace.Token.get_owner(token)

        case Mongo.find_one(:db, "user", %{_id: owner}) do
          nil -> redirect(conn, to: "/login") |> halt()
          _ -> assign(conn, :token_owner, owner)
        end

      0 ->
        redirect(conn, to: "/login") |> halt()
    end
  end
end
