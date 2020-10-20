# TODO: yeah these should be moved to a different module
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
    # TODO: use function capture instead
    |> Enum.map(fn x -> Base.url_encode64(x, padding: false) end)
    |> Enum.join(".")
  end

  def get_token_owner(token) do
    token
    |> String.split(".")
    |> List.first()
    |> Base.url_decode64!()
  end

  def urlencode(payload), do: Enum.map(payload, fn {k, v} -> "#{k}=#{v}" end) |> Enum.join("&")
end
