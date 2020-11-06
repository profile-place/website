defmodule ProfilePlace.Token do
  defstruct [
    :_id,
    :owner,
    :type,
    :timestamp
  ]

  @type t :: %__MODULE__{
          _id: String.t(),
          owner: integer,
          type: integer,
          timestamp: integer
        }

  @spec encode(t()) :: String.t()
  def encode(token) do
    [Integer.to_string(token.owner), Integer.to_string(token.timestamp), token._id]
    |> Enum.map(&encode_b64/1)
    |> Enum.join(".")
  end

  @spec get_owner(nil | String.t()) :: integer
  def get_owner(nil), do: nil

  def get_owner(token) do
    token
    |> String.split(".")
    |> List.first()
    |> Base.url_decode64!()
    |> String.to_integer()
  end

  @spec encode_b64(String.t()) :: String.t()
  defp encode_b64(x), do: Base.url_encode64(x, padding: false)
end
