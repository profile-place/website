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
end
