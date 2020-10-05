defmodule ProfilePlace.Repo do
  use Ecto.Repo,
    otp_app: :profile_place,
    adapter: Ecto.Adapters.Postgres
end
