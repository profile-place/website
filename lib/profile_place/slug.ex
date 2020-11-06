defmodule ProfilePlace.Slug do
  defstruct [
    :_id,
    :owner
  ]

  @type t :: %__MODULE__{
          _id: integer,
          owner: integer
        }

  @slug_regex ~r/([a-zA-Z]+\d+)|([a-zA-Z]+)/

  @doc """
  self-explanatory; I shouldn't have to write docs for this
  """
  @spec is_slug?(String.t()) :: boolean
  def is_slug?(slug), do: String.match?(slug, @slug_regex)
end
