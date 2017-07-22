defmodule Flatfoot.Spade do
  @moduledoc """
  The boundary for the Spade system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Flatfoot.{Repo, Clients}

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

  @doc """
  Gets a single backend. Returns nil if backend does not exist.

  ## Examples

      iex> get_backend(123)
      %Backend{}

      iex> get_backend(0)
      nil

  """
  def get_backend(id), do: Repo.get(Backend, id)

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

  @doc """
  Returns a single user with all associations preloaded throughout the depth. Returns `nil` if no user exists.

  ## Examples

      iex> get_user_preload(123)
      %User{}

      iex> get_user_preload(456)
      nil

  """
  def get_user_preload(id) do
    User
    |> where([user], user.id == ^id)
    |> join(:left, [user], _ in assoc(user, :wards))
    |> join(:left, [_user, wards], _ in assoc(wards, :ward_accounts))
    |> join(:left, [_user, _wards, ward_accounts], _ in assoc(ward_accounts, :backend))
    |> join(:left, [user, _wards, _ward_accounts, _backend], _ in assoc(user, :watchlists))
    |> join(:left, [_user, _wards, _ward_accounts, _backend, watchlists], _ in assoc(watchlists, :suspects))
    |> join(:left, [_user, _wards, _ward_accounts, _backend, _watchlists, suspects], _ in assoc(suspects, :suspect_accounts))
    |> join(:left, [_user, _wards, _ward_accounts, _backend, _watchlists, _suspects, suspect_accounts], _ in assoc(suspect_accounts, :backend))
    |> preload([_user, wards, ward_accounts, backend, watchlists, suspects, suspect_accounts, backend_suspects], [watchlists: {watchlists, suspects: {suspects, suspect_accounts: {suspect_accounts, backend: backend}}}, wards: {wards, ward_accounts: {ward_accounts, backend: backend}}])
    |> Repo.one
  end

  @doc """
  Pass a valid token and returns the corresponding Session.

  ## Examples

    iex> get_user_by_token(valid_token)
    {:ok, %User{}}

    iex> get_user_by_token(invalid_token)
    {:error, "Session does not exist. Please use valid token."}
  """
  def get_user_by_token(token) do
    if session = Clients.get_session_by_token(token) do
      User |> Repo.get(session.user_id)
    else
      {:error, "Session does not exist. Please use valid token."}
    end
  end

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
  Give a user_id, returns a list of wards for a given user. Returns empty list of no results.

  ## Examples

      iex> list_wards(12)
      [%Ward{}, ...]

      iex> list_wards(invalid_user_id)
      []

  """
  def list_wards(user_id) do
    Repo.all from t in Ward, where: t.user_id == ^user_id
  end

  @doc """
  Give a user_id, returns a list of wards for a given user and preloads all associations. Returns empty list if no results

  ## Examples

      iex> list_wards_preload(12)
      [%Ward{}, ...]

      iex> list_wards_preload(invalid_user_id)
      []
  """
  def list_wards_preload(user_id) do
    Ward
    |> where([wards], wards.user_id == ^user_id)
    |> join(:left, [wards], _ in assoc(wards, :ward_accounts))
    |> join(:left, [_, ward_accounts], _ in assoc(ward_accounts, :backend))
    |> preload([_, ward_accounts, backend], [ward_accounts: {ward_accounts, backend: backend}])
    |> Repo.all
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
  Returns a single ward. Returns nil if ward does not exist.

  ## Examples

      iex> get_ward!(123)
      %Ward{}

      iex> get_ward!(456)
      nil

  """
  def get_ward(id), do: Repo.get(Ward, id)

  @doc """
  Returns a single ward with all associations preloaded. Returns nil if no results.

  ## Examples

      iex> get_ward_preload(123)
      %Ward{}

      iex> get_ward_preload(invalid_id)
      nil

  """
  def get_ward_preload(id) do
    Ward
    |> where([wards], wards.id == ^id)
    |> join(:left, [wards], _ in assoc(wards, :ward_accounts))
    |> join(:left, [_, ward_accounts], _ in assoc(ward_accounts, :backend))
    |> preload([_, ward_accounts, backend], [ward_accounts: {ward_accounts, backend: backend}])
    |> Repo.one
  end

  @doc """
  Returns a single ward with ward_results associations preloaded. Returns nil if no results.

  ## Examples

      iex> get_ward_preload_with_results(123)
      %Ward{}

      iex> get_ward_preload_with_results(invalid_id)
      nil

  """
  def get_ward_preload_with_results(id) do
    Ward
    |> where([wards], wards.id == ^id)
    |> join(:left, [wards], _ in assoc(wards, :ward_accounts))
    |> join(:left, [_, ward_accounts], _ in assoc(ward_accounts, :backend))
    |> join(:left, [_, ward_accounts], _ in assoc(ward_accounts, :ward_results))
    |> preload([_, ward_accounts, backend, ward_results], [ward_accounts: {ward_accounts, backend: backend, ward_results: ward_results}])
    |> Repo.one
  end

  @doc """
  Given a Ward id, will delete that Ward. Will raise Ecto.NoResultsError if ward does not exist.

  ## Examples

      iex> delete_ward(135)
      {:ok, %Ward{}}

      iex> delete_ward(0)
      ** (Ecto.NoResultsError)

  """
  def delete_ward(id) do
    ward = get_ward!(id) |> Repo.preload(:ward_accounts)
    ward_accounts = ward.ward_accounts

    ward_accounts
    |> Enum.each(fn(ward_account) ->
      ward_account =
        ward_account
        |> Repo.preload(:ward_results)
      ward_account.ward_results |> Enum.each(&delete_ward_result(&1.id))
      delete_ward_account(ward_account.id)
    end)

    ward
    |> Repo.delete
  end

  @doc """
  Updates a ward.

  ## Examples

      iex> update_ward!(ward, %{field: new_value})
      {:ok, %Ward{}}

      iex> update_ward!(0, %{field: new_value})
      ** (Ecto.NoResultsError)

      iex> update_ward!(ward, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ward!(id, attrs) do
    get_ward!(id)
    |> ward_update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a ward. If the ward doesn't exists, returns nil.

  ## Examples

      iex> update_ward(ward, %{field: new_value})
      {:ok, %Ward{}}

      iex> update_ward(ward, %{field: bad_value})
      nil

  """
  def update_ward(id, attrs) do
    if ward = get_ward(id) do
      ward
      |> ward_update_changeset(attrs)
      |> Repo.update()
    else
      nil
    end
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
  Give a ward id, returns a list of ward_accounts for a given ward. Returns empty list if no ward_accounts for a given ward id.

  ## Examples

      iex> list_ward_accounts(12)
      [%WardAccount{}, ...]

      iex> list_ward_accounts(0)
      []

  """
  def list_ward_accounts(ward_id) do
    Repo.all from t in WardAccount, where: t.ward_id == ^ward_id
  end

  @doc """
  Returns a single ward account. Raises `Ecto.NoResultsError` if the WardAccount does not exist.

  ## Examples

      iex> get_ward_account!(123)
      %WardAccount{}

      iex> get_ward_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ward_account!(id), do: Repo.get!(WardAccount, id)

  @doc """
  Returns a single ward account. Returns nil if WardAccount does not exist.

  ## Examples

      iex> get_ward_account(123)
      %WardAccount{}

      iex> get_ward_account(0)
      nil

  """
  def get_ward_account(id), do: Repo.get(WardAccount, id)

  @doc """
  Returns a single WardAccount with backend and ward_results associations preloaded.

  Raises `Ecto.NoResultsError` if the WardAccount does not exist.

  ## Examples

      iex> get_ward_account_preload!(123)
      %WardAccount{}

      iex> get_ward_account_preload!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ward_account_preload!(id) do
    WardAccount
    |> where([ward_account], ward_account.id == ^id)
    |> join(:left, [ward_account], _ in assoc(ward_account, :backend))
    |> preload([_, backend], [backend: backend])
    |> preload(:ward_results)
    |> Repo.one!
  end

  @doc """
  Given a WardAccount id, will delete that WardAccount.

  ## Examples

      iex> delete_ward_account(135)
      {:ok, %WardAccount{}}

      iex> delete_ward_account(0)
      ** (Ecto.NoResultsError)
  """
  def delete_ward_account(id) do
    get_ward_account!(id)
    |> Repo.delete
  end

  @doc """
  Updates a ward_account. If no ward_account exists for id, raises error. If invalid params, will return :error and a changeset with the errors.

  ## Examples

      iex> update_ward_account(ward_account, %{field: new_value})
      {:ok, %WardAccount{}}

      iex> update_ward_account(0, %{field: new_value})
      ** (Ecto.NoResultsError)

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
  Give a user id, returns a list of watchlists for a given user. Preloads suspects by default. Returns empty list if no results or invalid user_id.

  ## Examples

      iex> list_watchlists(12)
      [%Watchlist{}, ...]

      iex> list_watchlists(0)
      []

  """
  def list_watchlists(user_id) do
    Repo.all from w in Watchlist, where: w.user_id == ^user_id
  end

  @doc """
  Give a user id, returns a list of watchlists for a given user and preloads all by default. Returns empty list if no results or invalid user_id.

  ## Examples

      iex> list_watchlists_preload(12)
      [%Watchlist{}, ...]

      iex> list_watchlists_preload(0)
      []

  """
  def list_watchlists_preload(user_id) do
    Watchlist
    |> where([watchlist], watchlist.user_id == ^user_id)
    |> join(:left, [watchlist], _ in assoc(watchlist, :suspects))
    |> join(:left, [_, suspects], _ in assoc(suspects, :suspect_accounts))
    |> join(:left, [_, _, suspect_accounts], _ in assoc(suspect_accounts, :backend))
    |> preload([_, suspects, suspect_accounts, backend], [suspects: {suspects, suspect_accounts: {suspect_accounts, backend: backend}}])
    |> Repo.all
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
  Returns a single watchlist and preloads all by default.

  Raises `Ecto.NoResultsError` if the Watchlist does not exist.

  ## Examples

      iex> get_watchlist_preload!(123)
      %Watchlist{}

      iex> get_watchlist_preload!(456)
      ** (Ecto.NoResultsError)

  """
  def get_watchlist_preload!(id) do
    Watchlist
    |> where([watchlist], watchlist.id == ^id)
    |> join(:left, [watchlist], _ in assoc(watchlist, :suspects))
    |> join(:left, [_, suspects], _ in assoc(suspects, :suspect_accounts))
    |> join(:left, [_, _, suspect_accounts], _ in assoc(suspect_accounts, :backend))
    |> preload([_, suspects, suspect_accounts, backend], [suspects: {suspects, suspect_accounts: {suspect_accounts, backend: backend}}])
    |> Repo.one!
  end

  @doc """
  Given a Watchlist id, will delete that Watchlist. Raises error if invalid watchlist id.

  ## Examples

      iex> delete_watchlist(135)
      {:ok, %Watchlist{}}

      iex> delete_watchlist(0)
      ** (Ecto.NoResultsError)

  """
  def delete_watchlist(id) do
    get_watchlist!(id)
    |> Repo.delete
  end

  @doc """
  With a valid watchlist id and attributes, updates a watchlist. Raises error if invalid watchlist id. Returns error and changeset if attributes are invalid.

  ## Examples

      iex> update_watchlist(watchlist_id, %{field: new_value})
      {:ok, %Watchlist{}}

      iex> update_watchlist(0, %{field: new_value})
      ** (Ecto.NoResultsError)

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
  Give a watchlist id, returns a list of watchlists for a given user. Invalid watchlist id or no suspects for a given watchlist id will return an empty list.

  ## Examples

      iex> list_suspects(12)
      [%Suspect{}, ...]

      iex> list_suspects(0)
      []

  """
  def list_suspects(watchlist_id) do
    Repo.all from t in Suspect, where: t.watchlist_id == ^watchlist_id
  end

  @doc """
  Give a watchlist id, returns a list of watchlists for a given user. Invalid watchlist id or no suspects for a given watchlist id will return an empty list.

  ## Examples

      iex> list_suspects_preload(12)
      [%Suspect{}, ...]

      iex> list_suspects_preload(0)
      []

  """
  def list_suspects_preload(watchlist_id) do
    Suspect
    |> where([suspects], suspects.watchlist_id == ^watchlist_id)
    |> join(:left, [suspects], _ in assoc(suspects, :suspect_accounts))
    |> join(:left, [_, suspect_accounts], _ in assoc(suspect_accounts, :backend))
    |> preload([_, suspect_accounts, backend], [suspect_accounts: {suspect_accounts, backend: backend}])
    |> Repo.all
  end

  @doc """
  Returns a single suspect. Raises `Ecto.NoResultsError` if the Suspect does not exist.

  ## Examples

      iex> get_suspect!(123)
      %Suspect{}

      iex> get_suspect!(456)
      ** (Ecto.NoResultsError)

  """
  def get_suspect!(id), do: Repo.get!(Suspect, id)

  @doc """
  Returns a single suspect and preloads all associationsby default. Raises `Ecto.NoResultsError` if the Suspect does not exist.

  ## Examples

      iex> get_suspect_preload!(123)
      %Suspect{}

      iex> get_suspect_preload!(456)
      ** (Ecto.NoResultsError)

  """
  def get_suspect_preload!(id) do
    Suspect
    |> where([suspects], suspects.id == ^id)
    |> join(:left, [suspects], _ in assoc(suspects, :suspect_accounts))
    |> join(:left, [_, suspect_accounts], _ in assoc(suspect_accounts, :backend))
    |> preload([_, suspect_accounts, backend], [suspect_accounts: {suspect_accounts, backend: backend}])
    |> Repo.one!
  end

  @doc """
  Given a Suspect id, will delete that Suspect. Raises error with invalid suspect id.

  ## Examples

      iex> delete_suspect(135)
      {:ok, %Suspect{}}

      iex> delete_suspect(0)
      ** (Ecto.NoResultsError)

  """
  def delete_suspect(id) do
    get_suspect!(id)
    |> Repo.delete
  end

  @doc """
  With a valid suspect id and attributes, updates a suspect. Invalid suspect id will raise error. Invalid fields will return an error and a changeset containing the errors.

  ## Examples

      iex> update_suspect(suspect_id, %{field: new_value})
      {:ok, %Suspect{}}

      iex> update_suspect(0, %{field: new_value})
      ** (Ecto.NoResultsError)

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
  Give a suspect id, returns a list of suspect accounts for a given user. Invalid suspect_account id or no suspect_accounts will return an empty list.

  ## Examples

      iex> list_suspect_accounts(12)
      [%SuspectAccount{}, ...]

      iex> list_suspect_accounts(0)
      []

  """
  def list_suspect_accounts(suspect_id) do
    Repo.all from t in SuspectAccount, where: t.suspect_id == ^suspect_id
  end

  @doc """
  Returns a single suspect account. Raises `Ecto.NoResultsError` if the SuspectAccount does not exist.

  ## Examples

      iex> get_suspect_account!(123)
      %SuspectAccount{}

      iex> get_suspect_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_suspect_account!(id), do: Repo.get!(SuspectAccount, id)

  @doc """
  Given a SuspectAccount id, will delete that SuspectAccount. Raises error if SuspectAccount does not exist.

  ## Examples

      iex> delete_suspect_account(135)
      {:ok, %SuspectAccount{}}

      iex> delete_suspect_account(0)
      ** (Ecto.NoResultsError)

  """
  def delete_suspect_account(id) do
    get_suspect_account!(id)
    |> Repo.delete
  end

  @doc """
  With a valid suspect account id and attributes, updates a suspect account. Raises error if SuspectAccount does not exist. Returns error and a changeset with errors if invalid attributes are passed.

  ## Examples

      iex> update_suspect_account(suspect_account_id, %{field: new_value})
      {:ok, %SuspectAccount{}}

      iex> update_suspect_account(0, %{field: new_value})
      ** (Ecto.NoResultsError)

      iex> update_suspect_account(suspect_account_id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_suspect_account(id, attrs) do
    get_suspect_account!(id)
    |> suspect_account_update_changeset(attrs)
    |> Repo.update()
  end

  ###############
  # Ward Result #
  ###############

  alias Flatfoot.Spade.WardResult

  @doc """
  Given a ward id, returns a list of ward results for that ward. Invalid id or WardAccount with no WardResults will return empty list.

  Can provide optional as_of parameter that specifies the earliest date to be included in the results. Must be in "YYYY-MM-DD". If not in that format, raises an error.

  ## Examples

      iex> list_ward_results(12)
      [%WardResult{}, ...]

      iex> list_ward_results(0)
      []

      iex> list_ward_results(12, "2016-10-05")
      [%WardResult{}, ...]

      iex> list_ward_results(12, "invalid")
      ** (ArgumentError)

  """
  def list_ward_results(ward_account_id) do
    Repo.all from r in WardResult, where: r.ward_account_id == ^ward_account_id
  end
  def list_ward_results(ward_account_id, as_of) do
    as_of_dtg = NaiveDateTime.from_iso8601!("#{as_of} 00:00:00.00")

    if as_of_dtg do
      Repo.all from r in WardResult, where: r.ward_account_id == ^ward_account_id and r.timestamp > ^as_of_dtg
    else
      nil
    end
  end

  @doc """
  Given a session token, will return a list of results for each ward_account belonging to the user. Returns empty array if no results stored.

  Can provide optional as_of parameter that specifies the earliest date to be included in the results. Must be in "YYYY-MM-DD". If not in that format, raises an error.

  ## Examples

      iex> list_ward_results_by_user(token)
      [%WardResult{}, ...]

      iex> list_ward_results_by_user(invalid_token)
      []

      iex> list_ward_results(token, "2017-01-21")
      [%WardResult{}, ...]

      iex> list_ward_results(token, "invalid")
      ** (ArgumentError)
  """
  def list_ward_results_by_user(token, as_of \\ "0000-01-01") do
    if as_of_dtg = NaiveDateTime.from_iso8601!("#{as_of} 00:00:00.00") do
      ward_account_ids =
        get_user_by_token(token)
        |> Map.get(:id)
        |> get_user_preload()
        |> Map.get(:wards)
        |> Enum.map(&(&1.ward_accounts))
        |> List.flatten
        |> Enum.map(&(&1.id |> Integer.to_string))

      WardResult
      |> where([result], result.ward_account_id in ^ward_account_ids and result.timestamp > ^as_of_dtg)
      |> order_by([desc: :rating, desc: :timestamp])
      |> Repo.all
    end
  end

  @doc """
  Returns a single ward result. Returns nil if WardResult does not exist.

  ## Examples

      iex> get_ward_result(123)
      %WardResult{}

      iex> get_ward_result(0)
      nil

  """
  def get_ward_result(id), do: Repo.get(WardResult, id)

  @doc """
  Given a WardResult id, will delete that WardResult. Raises error if WardResult does not exist.

  ## Examples

      iex> delete_ward_result(135)
      {:ok, %WardResult{}}

      iex> delete_ward_result(0)
      ** (FunctionClauseError)

  """
  def delete_ward_result(id) do
    get_ward_result(id)
    |> Repo.delete
  end

  ##############
  # Changesets #
  ##############

  defp ward_changeset(%Ward{} = ward, attrs) do
    ward
    |> cast(attrs, [:name, :relationship, :user_id, :active])
    |> validate_required([:name, :user_id])
  end

  defp ward_update_changeset(%Ward{} = ward, attrs) do
    ward
    |> cast(attrs, [:name, :relationship, :active])
    |> validate_required([:name, :relationship, :active])
  end

  defp ward_account_changeset(%WardAccount{} = ward_account, attrs) do
    ward_account
    |> cast(attrs, [:handle, :ward_id, :backend_id])
    |> validate_required([:handle, :ward_id, :backend_id])
  end

  defp ward_acount_update_changeset(%WardAccount{} = ward_account, attrs) do
    ward_account
    |> cast(attrs, [:handle, :last_msg, :backend_id])
    |> validate_required([:handle, :backend_id])
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
