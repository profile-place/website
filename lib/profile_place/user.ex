defmodule ProfilePlace.User do
  defstruct [
    :_id,
    :connections,
    :email,
    :max_slugs,
    :password
  ]

  @type t :: %__MODULE__{
          _id: integer,
          connections: list,
          email: String.t(),
          max_slugs: integer,
          password: String.t()
        }
end
