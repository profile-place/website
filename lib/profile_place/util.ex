defmodule ProfilePlace.Util do
  @doc """
  Mongo.find_one/4 but parses result to `nil` or a map where the keys are atoms.
  We pretty much only use this if we care about the result, not just in the context of "oh this exists? aight".
  """
  def find_one(coll, filter, opts \\ []) do
    case Mongo.find_one(:db, coll, filter, opts) do
      nil -> nil
      x -> Map.new(x, fn {k, v} -> {String.to_atom(k), v} end)
    end
  end

  @doc """
  Decodes JSON string and maps keys to atoms
  """
  def decode_to_atoms(string) do
    string |> Jason.decode!() |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
  end

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

    IO.inspect(obj)

    # ah yes there should be app-specific checks to see if username has been changed or whatever
    case Mongo.find_one(:db, "connection", %{_id: obj._id}) do
      nil -> Mongo.insert_one(:db, "connection", obj)
      _ -> Mongo.find_one_and_update(:db, "connection", %{_id: obj._id}, %{"$set" => obj})
    end
  end
end
