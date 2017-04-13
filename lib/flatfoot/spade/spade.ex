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

  ########
  # Ward #
  ########

  alias Flatfoot.Spade.Ward

  @doc """
  Creates a ward with valid params

  ## Examples

      iex> create_ward(%{name: "Jan Jones", relationship: "daughter", user_id: 12)
      {:ok, %Ward{name: "Jan Jones", relationship: "daughter", user_id: 12, active: true}}

      iex> create_ward(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_ward(attrs) do
    %Ward{}
    |> ward_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Give a user_id, returns a list of wards for a given user.

  ## Examples

      iex> list_wards(12)
      [%Ward{}, ...]

  """
  def list_wards(user_id) do
    Repo.all from t in Ward, where: t.user_id == ^user_id
  end

  @doc """
  Returns a single ward.

  Raises `Ecto.NoResultsError` if the Ward does not exist.

  ## Examples

      iex> get_ward!(123)
      %Ward{}

      iex> get_ward!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ward!(id), do: Repo.get!(Ward, id)

  @doc """
  Given a Ward id, will delete that Ward.

  ## Examples

      iex> delete_ward(135)
      {:ok, %Ward{}}

      iex> delete_ward(0)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ward(id) do
    get_ward!(id)
    |> Repo.delete
  end

  @doc """
  Updates a ward.

  ## Examples

      iex> update_ward(ward, %{field: new_value})
      {:ok, %Ward{}}

      iex> update_ward(ward, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ward(id, attrs) do
    get_ward!(id)
    |> ward_update_changeset(attrs)
    |> Repo.update()
  end

  ################
  # Ward Account #
  ################

  alias Flatfoot.Spade.WardAccount

  @doc """
  Creates a ward account with valid params

  ## Examples

      iex> create_ward_account(%{handle: "@realOneal", ward_id: 4, backend_id: 12)
      {:ok, %WardAccount{handle: "@realOneal", ward_id: 4, backend_id: 12}}

      iex> create_ward_account(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_ward_account(attrs) do
    %WardAccount{}
    |> ward_account_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Give a ward id, returns a list of ward_accounts for a given ward.

  ## Examples

      iex> list_ward_accounts(12)
      [%WardAccount{}, ...]

  """
  def list_ward_accounts(ward_id) do
    Repo.all from t in WardAccount, where: t.ward_id == ^ward_id
  end

  @doc """
  Returns a single ward account.

  Raises `Ecto.NoResultsError` if the WardAccount does not exist.

  ## Examples

      iex> get_ward_account!(123)
      %WardAccount{}

      iex> get_ward_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ward_account!(id), do: Repo.get!(WardAccount, id)

  @doc """
  Given a WardAccount id, will delete that WardAccount.

  ## Examples

      iex> delete_ward_account(135)
      {:ok, %WardAccount{}}

      iex> delete_ward_account(0)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ward_account(id) do
    get_ward_account!(id)
    |> Repo.delete
  end

  @doc """
  Updates a ward_account.

  ## Examples

      iex> update_ward_account(ward_account, %{field: new_value})
      {:ok, %WardAccount{}}

      iex> update_ward_account(ward_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ward_account(id, attrs) do
    get_ward_account!(id)
    |> ward_acount_update_changeset(attrs)
    |> Repo.update()
  end

  #############
  # Watchlist #
  #############

  alias Flatfoot.Spade.Watchlist

  @doc """
  Creates a watchlist with valid params

  ## Examples

      iex> create_watchlist(%{name: "Bullies", user_id: 4)
      {:ok, %Watchlist{name: "Bullies", user_id: 4}}

      iex> create_watchlist(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_watchlist(attrs) do
    %Watchlist{}
    |> watchlist_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Give a user id, returns a list of watchlists for a given user.

  ## Examples

      iex> list_watchlists(12)
      [%Watchlist{}, ...]

  """
  def list_watchlists(user_id) do
    Repo.all from t in Watchlist, where: t.user_id == ^user_id
  end

  @doc """
  Returns a single watchlist.

  Raises `Ecto.NoResultsError` if the Watchlist does not exist.

  ## Examples

      iex> get_watchlist!(123)
      %Watchlist{}

      iex> get_watchlist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_watchlist!(id), do: Repo.get!(Watchlist, id)

  @doc """
  Given a Watchlist id, will delete that Watchlist.

  ## Examples

      iex> delete_watchlist(135)
      {:ok, %Watchlist{}}

      iex> delete_watchlist(0)
      {:error, %Ecto.Changeset{}}

  """
  def delete_watchlist(id) do
    get_watchlist!(id)
    |> Repo.delete
  end

  @doc """
  With a valid watchlist id and attributes, updates a watchlist.

  ## Examples

      iex> update_watchlist(watchlist_id, %{field: new_value})
      {:ok, %Watchlist{}}

      iex> update_watchlist(watchlist_id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_watchlist(id, attrs) do
    get_watchlist!(id)
    |> watchlist_update_changeset(attrs)
    |> Repo.update()
  end

  ###########
  # Suspect #
  ###########

  alias Flatfoot.Spade.Suspect

  @doc """
  Creates a suspect with valid params

  ## Examples

      iex> create_suspect(%{name: "Bullies", category: "not nice", user_id: 4)
      {:ok, %Suspect{name: "Bullies", category: "not nice", notes: nil, status: true, user_id: 4}}

      iex> create_suspect(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_suspect(attrs) do
    %Suspect{}
    |> suspect_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Give a watchlist id, returns a list of watchlists for a given user.

  ## Examples

      iex> list_suspects(12)
      [%Suspect{}, ...]

  """
  def list_suspects(watchlist_id) do
    Repo.all from t in Suspect, where: t.watchlist_id == ^watchlist_id
  end

  @doc """
  Returns a single suspect.

  Raises `Ecto.NoResultsError` if the Suspect does not exist.

  ## Examples

      iex> get_suspect!(123)
      %Suspect{}

      iex> get_suspect!(456)
      ** (Ecto.NoResultsError)

  """
  def get_suspect!(id), do: Repo.get!(Suspect, id)

  @doc """
  Given a Suspect id, will delete that Suspect.

  ## Examples

      iex> delete_suspect(135)
      {:ok, %Suspect{}}

      iex> delete_suspect(0)
      {:error, %Ecto.Changeset{}}

  """
  def delete_suspect(id) do
    get_suspect!(id)
    |> Repo.delete
  end

  @doc """
  With a valid suspect id and attributes, updates a suspect.

  ## Examples

      iex> update_suspect(suspect_id, %{field: new_value})
      {:ok, %Suspect{}}

      iex> update_suspect(suspect_id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_suspect(id, attrs) do
    get_suspect!(id)
    |> suspect_update_changeset(attrs)
    |> Repo.update()
  end

  ###################
  # Suspect Account #
  ###################

  alias Flatfoot.Spade.SuspectAccount

  @doc """
  Creates a suspect account with valid params

  ## Examples

      iex> create_suspect_account(%{handle: "@bully", suspect_id: 4, backend_id: 3)
      {:ok, %SuspectAccount{handle: "@bully", suspect_id: 4, backend_id: 3}}

      iex> create_suspect_account(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_suspect_account(attrs) do
    %SuspectAccount{}
    |> suspect_account_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Give a suspect id, returns a list of suspect accounts for a given user.

  ## Examples

      iex> list_suspect_accounts(12)
      [%SuspectAccount{}, ...]

  """
  def list_suspect_accounts(suspect_id) do
    Repo.all from t in SuspectAccount, where: t.suspect_id == ^suspect_id
  end

  @doc """
  Returns a single suspect account.

  Raises `Ecto.NoResultsError` if the SuspectAccount does not exist.

  ## Examples

      iex> get_suspect_account!(123)
      %SuspectAccount{}

      iex> get_suspect_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_suspect_account!(id), do: Repo.get!(SuspectAccount, id)

  @doc """
  Given a SuspectAccount id, will delete that SuspectAccount.

  ## Examples

      iex> delete_suspect_account(135)
      {:ok, %SuspectAccount{}}

      iex> delete_suspect_account(0)
      {:error, %Ecto.Changeset{}}

  """
  def delete_suspect_account(id) do
    get_suspect_account!(id)
    |> Repo.delete
  end

  @doc """
  With a valid suspect account id and attributes, updates a suspect account.

  ## Examples

      iex> update_suspect_account(suspect_account_id, %{field: new_value})
      {:ok, %SuspectAccount{}}

      iex> update_suspect_account(suspect_account_id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_suspect_account(id, attrs) do
    get_suspect_account!(id)
    |> suspect_account_update_changeset(attrs)
    |> Repo.update()
  end

  ##############
  # Changesets #
  ##############

  defp ward_changeset(%Ward{} = ward, attrs) do
    ward
    |> cast(attrs, [:name, :relationship, :user_id])
    |> validate_required([:name, :user_id])
  end

  defp ward_update_changeset(%Ward{} = ward, attrs) do
    ward
    |> cast(attrs, [:name, :relationship])
    |> validate_required([:name])
  end

  defp ward_account_changeset(%WardAccount{} = ward_account, attrs) do
    ward_account
    |> cast(attrs, [:handle, :ward_id, :backend_id])
    |> validate_required([:handle, :ward_id, :backend_id])
  end

  defp ward_acount_update_changeset(%WardAccount{} = ward_account, attrs) do
    ward_account
    |> cast(attrs, [:handle])
    |> validate_required([:handle])
  end

  defp watchlist_changeset(%Watchlist{} = watchlist, attrs) do
    watchlist
    |> cast(attrs, [:user_id, :name])
    |> validate_required([:user_id, :name])
  end

  defp watchlist_update_changeset(%Watchlist{} = watchlist, attrs) do
    watchlist
    |> cast(attrs, [:name])
    |> validate_required([:user_id, :name])
  end

  defp suspect_changeset(%Suspect{} = suspect, attrs) do
    suspect
    |> cast(attrs, [:name, :category, :notes, :active, :watchlist_id])
    |> validate_required([:name, :watchlist_id])
  end

  defp suspect_update_changeset(%Suspect{} = suspect, attrs) do
    suspect
    |> cast(attrs, [:name, :category, :notes, :active])
    |> validate_required([:name, :watchlist_id])
  end

  defp suspect_account_changeset(%SuspectAccount{} = suspect, attrs) do
    suspect
    |> cast(attrs, [:handle, :suspect_id, :backend_id])
    |> validate_required([:handle, :suspect_id, :backend_id])
  end

  defp suspect_account_update_changeset(%SuspectAccount{} = suspect, attrs) do
    suspect
    |> cast(attrs, [:handle])
    |> validate_required([:handle, :suspect_id, :backend_id])
  end
end
