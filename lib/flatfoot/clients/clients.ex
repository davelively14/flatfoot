defmodule Flatfoot.Clients do
  @moduledoc """
  The boundary for the Clients system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Flatfoot.Repo

  alias Flatfoot.Clients.{User, Session, NotificationRecord}

  ########
  # User #
  ########

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets the first user matching the providing params.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_by_username(username: "dlives")
      %User{}

      iex> get_user_by_username(username: "not_username")
      ** (Ecto.NoResultsError)

  """
  def get_user_by_username(username), do: Repo.get_by(User, username: username)

  @doc """
  Gets the first user matching the providing params.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_by_username(username: "dlives")
      %User{}

      iex> get_user_by_username(username: "not_username")
      ** (Ecto.NoResultsError)

  """
  def get_user_by_session(session), do: Repo.get(User, session.user_id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{username: username, email: email, password: password})
      {:ok, %User{}}

      iex> create_user(%{username: nil, email: nil, password: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> user_registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> register_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def register_user(%User{} = user) do
    user_registration_changeset(user, %{})
  end

  ###########
  # Session #
  ###########

  @doc """
  Pass a valid username and password and returns a Session.

  ## Examples

      iex> login(%{user_id: valid_id})
      {:ok, %Session{}}

      iex> login(%{user_id: invalid_id})
      {:error, %Ecto.Changeset{}}

  """
  def login(attrs) do
    %Session{}
    |> session_registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Pass a valid token and returns the corresponding Session.

  ## Examples

    iex> get_session_by_token(valid_token)
    {:ok, %Session{}}

    iex> get_session_by_token(invalid_token)
    :error
  """
  def get_session_by_token(token), do: Repo.get_by(Session, token: token)

  @doc """
  Pass a valid token and returns the corresponding Session.

  ## Examples

    iex> get_user_by_token(valid_token)
    {:ok, %Session{}}

    iex> get_user_by_token(invalid_token)
    :error
  """
  def get_user_by_token(token) do
    session = Session |> Repo.get_by(token: token)
    User |> Repo.get(session.user_id)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

      iex> register_session(session)
      %Ecto.Changeset{source: %Session{}}

  """
  def register_session(%Session{} = session) do
    session_registration_changeset(session, %{})
  end

  ######################
  # NotificationRecord #
  ######################

  @doc """
  Creates a notificaion record. The `role` and `threshold` attributes are optional. The `role` attribute defaults to `nil` and `threshold` defaults to 0.

  ## Examples

      iex> create_notification_record(%{nickname: "Dad", email: "dl@it.com", user_id: 1, role: "family", threshold: 0})
      {:ok, %NotificationRecord{}}

      iex> create_notification_record(%{nickname: nil, email: "dlom", user_id: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification_record(attrs) do
    %NotificationRecord{}
    |> notification_record_changeset(attrs)
    |> Repo.insert()
  end

  ##############
  # Changesets #
  ##############

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})/)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  defp user_registration_changeset(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash
  end

  defp session_changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end

  defp session_registration_changeset(%Session{} = session, attrs) do
    session
    |> session_changeset(attrs)
    |> put_change(:token, SecureRandom.urlsafe_base64())
  end

  def notification_record_changeset(%NotificationRecord{} = record, attrs) do
    record
    |> cast(attrs, [:nickname, :email, :role, :threshold, :user_id])
    |> validate_required([:nickname, :email, :user_id])
    |> validate_format(:email, ~r/([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})/)
  end

  #####################
  # Private Functions #
  #####################

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
