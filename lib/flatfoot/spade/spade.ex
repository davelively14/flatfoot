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

  ########
  # User #
  ########

  alias Flatfoot.Spade.User

  @doc """
  Returns a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ##########
  # Target #
  ##########

  alias Flatfoot.Spade.Target

  @doc """
  Creates a target with valid params

  ## Examples

      iex> create_target(%{name: "Jan Jones", relationship: "daughter", user_id: 12)
      {:ok, %Target{name: "Jan Jones", relationship: "daughter", user_id: 12, active: true}}

      iex> create_target(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_target(attrs) do
    %Target{}
    |> target_changeset(attrs)
    |> Repo.insert()
  end

  ##############
  # Changesets #
  ##############

  defp target_changeset(%Target{} = target, attrs) do
    target
    |> cast(attrs, [:name, :relationship, :user_id])
    |> validate_required([:name, :user_id])
  end
end
