defmodule ProfilePlace.Util do
  @doc """
  self-explanatory; I shouldn't have to write docs for this
  """
  def is_slug?(slug), do: String.match?(slug, ~r/([a-zA-Z]+\d+)|([a-zA-Z]+)/)

  @doc """
  Mongo.find_one/4 but parses result to `nil` or a map where the keys are atoms.
  We pretty much only use this if we care about the result, not just in the context of "oh this exists? aight".
  """
  # TODO: make this and find/3 work recursively
  def find_one(coll, filter, opts \\ []) do
    case Mongo.find_one(:db, coll, filter, opts) do
      nil -> nil
      x -> Map.new(x, &map_keys_to_atoms/1)
    end
  end

  @doc """
  Mongo.find/4 but parses the result to `nil` or a list of maps where the keys are atoms
  """
  def find(coll, filter, opts \\ []) do
    case Mongo.find(:db, coll, filter, opts) do
      [] ->
        nil

      # TODO: find better variable names lol
      x ->
        x
        |> Enum.to_list()
        |> Enum.map(fn y -> Map.new(y, &map_keys_to_atoms/1) end)
    end
  end

  @doc """
  Decodes JSON string and maps keys to atoms
  """
  def decode_to_atoms(string),
    do: string |> Jason.decode!() |> Map.new(&map_keys_to_atoms/1)

  @doc """
  Inserts an object into db. `obj` should be a JSON string returned
  from oauth; `token_owner` should be the token owner (duh); `app`
  should be the app which is being authenticated; `key` should be
  the second part of the key (id, username, whatever works)
  """
  def insert_into_db(obj, token_owner, app, key) do
    obj = decode_to_atoms(obj)

    obj =
      Map.merge(
        obj,
        %{
          _owner: token_owner,
          _id: "#{app}:#{obj[key]}"
        }
      )

    # ah yes there should be app-specific checks to see if username has been changed or whatever
    case Mongo.find_one(:db, "connection", %{_id: obj._id}) do
      nil -> Mongo.insert_one(:db, "connection", obj)
      _ -> Mongo.find_one_and_update(:db, "connection", %{_id: obj._id}, %{"$set" => obj})
    end
  end

  @doc """
  Gets the app name from a connection _id (for example discord:123456789 would return "discord")
  """
  def get_app(str), do: String.split(str, ":") |> List.first()

  def map_keys_to_atoms({k, v}) do
    if is_map(v),
      do: {String.to_atom(k), Map.new(v, &map_keys_to_atoms/1)},
      else: {String.to_atom(k), v}
  end
end
