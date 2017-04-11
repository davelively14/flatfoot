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

  @doc """
  Give a user_id, returns a list of targets for a given user.

  ## Examples

      iex> list_targets(12)
      [%Backend{}, ...]

  """
  def list_targets(user_id) do
    Repo.all from t in Target, where: t.user_id == ^user_id
  end

  @doc """
  Returns a single target.

  Raises `Ecto.NoResultsError` if the Target does not exist.

  ## Examples

      iex> get_target!(123)
      %Target{}

      iex> get_target!(456)
      ** (Ecto.NoResultsError)

  """
  def get_target!(id), do: Repo.get!(Target, id)

  ##############
  # Changesets #
  ##############

  defp target_changeset(%Target{} = target, attrs) do
    target
    |> cast(attrs, [:name, :relationship, :user_id])
    |> validate_required([:name, :user_id])
  end
end
