defmodule ProfilePlace.User do
  defstruct [
    :_id,
    :connections,
    :data,
    :display_name,
    :email,
    :max_slugs,
    :password
  ]

  @type t :: %__MODULE__{
          _id: integer,
          connections: list,
          data: __MODULE__.Data,
          display_name: String.t(),
          email: String.t(),
          max_slugs: integer,
          password: String.t()
        }

  defmodule Data do
    defstruct [
      :age,
      :bio
    ]

    @type t :: %__MODULE__{
            age: integer,
            bio: String.t()
          }
  end
end
