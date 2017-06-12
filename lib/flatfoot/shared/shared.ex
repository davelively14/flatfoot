defmodule Flatfoot.Shared do
  alias Flatfoot.Repo

  ########
  # User #
  ########

  alias Flatfoot.Shared.User

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user_id)
      {:ok, %User{}}

      iex> delete_user(user_id)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(user_id) do
    User |> Repo.get(user_id) |> Repo.delete
  end
end
