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
      [%Target{}, ...]

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

  @doc """
  Given a Target id, will delete that Target.

  ## Examples

      iex> delete_target(135)
      {:ok, %Target{}}

      iex> delete_target(0)
      {:error, %Ecto.Changeset{}}

  """
  def delete_target(id) do
    get_target!(id)
    |> Repo.delete
  end

  @doc """
  Updates a target.

  ## Examples

      iex> update_target(target, %{field: new_value})
      {:ok, %Target{}}

      iex> update_target(target, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_target(id, attrs) do
    get_target!(id)
    |> target_changeset(attrs)
    |> Repo.update()
  end

  ##################
  # Target Account #
  ##################

  alias Flatfoot.Spade.TargetAccount

  @doc """
  Creates a target account with valid params

  ## Examples

      iex> create_target_account(%{handle: "@realOneal", target_id: 4, backend_id: 12)
      {:ok, %TargetAccount{handle: "@realOneal", target_id: 4, backend_id: 12}}

      iex> create_target_account(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_target_account(attrs) do
    %TargetAccount{}
    |> target_account_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Give a target id, returns a list of target_accounts for a given target.

  ## Examples

      iex> list_target_accounts(12)
      [%TargetAccount{}, ...]

  """
  def list_target_accounts(target_id) do
    Repo.all from t in TargetAccount, where: t.target_id == ^target_id
  end

  @doc """
  Returns a single target account.

  Raises `Ecto.NoResultsError` if the TargetAccount does not exist.

  ## Examples

      iex> get_target_account!(123)
      %TargetAccount{}

      iex> get_target_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_target_account!(id), do: Repo.get!(TargetAccount, id)

  ##############
  # Changesets #
  ##############

  defp target_changeset(%Target{} = target, attrs) do
    target
    |> cast(attrs, [:name, :relationship, :user_id])
    |> validate_required([:name, :user_id])
  end

  defp target_account_changeset(%TargetAccount{} = target_account, attrs) do
    target_account
    |> cast(attrs, [:handle, :target_id, :backend_id])
    |> validate_required([:handle, :target_id, :backend_id])
  end
end
