defmodule ProfilePlace.App do
  @doc """
  Gets the app name from a connection _id (for example discord:123456789 would return "discord")
  """
  @spec get_app_name(String.t()) :: String.t()
  def get_app_name(str), do: String.split(str, ":") |> List.first()
end
