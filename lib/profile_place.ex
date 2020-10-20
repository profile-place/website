# TODO: yeah these should be moved to a different module
defmodule ProfilePlace do
  @moduledoc """
  ProfilePlace keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def gen_secret, do: :crypto.strong_rand_bytes(32) |> Base.encode16()

  def urlencode(payload), do: Enum.map(payload, fn {k, v} -> "#{k}=#{v}" end) |> Enum.join("&")
end
