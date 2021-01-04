defmodule ProfilePlace.Util do
  @moduledoc """
  Friendly reminder that this module should NOT exist. It's literally just a compilations of functions that could exist in better places
  """

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
    case Mongo.find(:db, coll, filter, opts) |> Enum.to_list() do
      [] ->
        nil

      # TODO: find better variable names lol
      x ->
        Enum.map(x, fn y -> Map.new(y, &map_keys_to_atoms/1) end)
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
    obj =
      Map.merge(
        obj,
        %{
          _owner: token_owner,
          _id: "#{app}:#{obj[key]}"
        }
      )

    case Mongo.find_one(:db, "connection", %{_id: obj._id}) do
      nil -> Mongo.insert_one(:db, "connection", obj)
      _ -> Mongo.find_one_and_update(:db, "connection", %{_id: obj._id}, %{"$set" => obj})
    end
  end

  # our tokens are already encoded since we handle them while getting data for insert_into_db/4
  # lmao this will need massive refactoring later, idc
  def save_tokens(obj, token_owner, app, key) do
    obj =
      Map.merge(
        obj,
        %{
          _owner: token_owner,
          _id: "#{app}:#{key}"
        }
      )

    case Mongo.find_one(:db, "token", %{_id: obj._id}) do
      nil -> Mongo.insert_one(:db, "token", obj)
      _ -> Mongo.find_one_and_update(:db, "token", %{_id: obj._id}, %{"$set" => obj})
    end
  end

  def map_keys_to_atoms({k, v}) do
    if is_map(v),
      do: {String.to_atom(k), Map.new(v, &map_keys_to_atoms/1)},
      else: {String.to_atom(k), v}
  end

  def component(name, assigns \\ %{}) do
    Phoenix.View.render(ProfilePlaceWeb.ComponentView, name <> ".html", assigns)
  end
end
