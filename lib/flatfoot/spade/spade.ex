defmodule Flatfoot.Spade do
  @moduledoc """
  The boundary for the Spade system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Flatfoot.Repo

  ###########
  # Backend #
  ###########

  alias Flatfoot.Spade.Backend

  @doc """
  Returns the list of backends.

  ## Examples

      iex> list_backends()
      [%Backend{}, ...]

  """
  def list_backends do
    Repo.all(Backend)
  end

  @doc """
  Gets a single backend.

  Raises `Ecto.NoResultsError` if the Backend does not exist.

  ## Examples

      iex> get_backend!(123)
      %Backend{}

      iex> get_backend!(456)
      ** (Ecto.NoResultsError)

  """
  def get_backend!(id), do: Repo.get!(Backend, id)
end
