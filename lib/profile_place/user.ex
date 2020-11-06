defmodule ProfilePlace.User do
  defstruct [
    :_id,
    :connections,
    :email,
    :password
  ]

  @type t :: %__MODULE__{
          _id: integer,
          connections: list,
          email: String.t(),
          password: String.t()
        }
end
