defmodule Flatfoot.Shared do
  alias Flatfoot.Repo

  ########
  # User #
  ########

  alias Flatfoot.Shared.User

  @doc """
  Deletes a User. If invalid user_id provided, will raise error.

  ## Examples

      iex> delete_user(user_id)
      {:ok, %User{}}

      iex> delete_user(user_id)
      ** (Ecto.NoResultsError)

  """
  def delete_user(user_id) do
    User |> Repo.get!(user_id) |> Repo.delete
  end
end
