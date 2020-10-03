defmodule ProfilePlace do
  @moduledoc """
  ProfilePlace keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def gen_secret, do: :crypto.strong_rand_bytes(32) |> Base.encode16()

  # TODO: write types for this
  def encode_token(token) do
    [Integer.to_string(token.owner), Integer.to_string(token.timestamp), token._id]
    |> Enum.map(fn x -> Base.url_encode64(x, padding: false) end)
    |> Enum.join(".")
  end
end
