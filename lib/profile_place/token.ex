defmodule ProfilePlace.Token do
  # TODO: write types for this
  def encode(token) do
    [Integer.to_string(token.owner), Integer.to_string(token.timestamp), token._id]
    # TODO: use function capture instead
    |> Enum.map(fn x -> Base.url_encode64(x, padding: false) end)
    |> Enum.join(".")
  end

  def get_owner(nil), do: nil

  def get_owner(token) do
    token
    |> String.split(".")
    |> List.first()
    |> Base.url_decode64!()
    |> String.to_integer()
  end
end
