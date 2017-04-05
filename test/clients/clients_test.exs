defmodule Flatfoot.ClientsTest do
  use Flatfoot.DataCase

  alias Flatfoot.{Clients, Clients.User, Clients.Session, Clients.NotificationRecord, Clients.Settings}

  @username Faker.Internet.user_name
  @email Faker.Internet.free_email
  @password Faker.Code.isbn
  @new_email Faker.Internet.free_email
  @new_username Faker.Internet.user_name

  @create_attrs %{email: @email, password: @password, username: @username}

  ########
  # User #
  ########

  describe "list_users/0" do
    test "returns all users" do
      users = insert_list(5, :user)
      assert Clients.list_users() == users
    end

    test "returns empty array if no users" do
      assert Clients.list_users() == []
    end
  end

  describe "get_user!/1" do
    test "returns the user with given id" do
      user = insert(:user)
      assert Clients.get_user!(user.id) == user
    end

    test "raises error if no user exists with given id" do
      assert_raise Ecto.NoResultsError, fn -> Clients.get_user!(0) end
    end
  end

  describe "create_user/1" do
    test "with valid data creates a user" do
      assert {:ok, %User{} = user} = Clients.create_user(@create_attrs)
      assert user.email == @email
      assert user.username == @username
    end

    test "with missing data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_user(%{username: @username, password: @password})
      assert {:error, %Ecto.Changeset{}} = Clients.create_user(%{email: @email, password: @password})
      assert {:error, %Ecto.Changeset{}} = Clients.create_user(%{username: @username, email: @email})
    end

    test "with wrong email format returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_user(%{username: @username, password: @password, email: "dave@gmail"})
      assert {:error, %Ecto.Changeset{}} = Clients.create_user(%{username: @username, password: @password, email: "dave@gmail."})
      assert {:error, %Ecto.Changeset{}} = Clients.create_user(%{username: @username, password: @password, email: "gmail.com"})
    end
  end

  describe "update_user/2" do
    test "with valid data updates the user" do
      user = insert(:user)
      assert {:ok, user} = Clients.update_user(user, %{username: @new_username, email: @new_email})
      assert %User{} = user
      assert user.email == @new_email
      assert user.username == @new_username
    end

    test "with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Clients.update_user(user, %{username: ""})
      assert {:error, %Ecto.Changeset{}} = Clients.update_user(user, %{email: ""})
      assert user == Clients.get_user!(user.id)
    end
  end

  describe "delete_user/1" do
    test "deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Clients.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_user!(user.id) end
    end

    test "deletes associated sessions and notification records" do
      user = insert(:user)
      session = insert(:session, user: user)
      insert(:notification_record, user: user)

      assert session.id == Clients.get_session_by_token(session.token) |> Map.get(:id)
      assert {:ok, %User{}} = Clients.delete_user(user)
      assert nil == Clients.get_session_by_token(session.token)
      assert [] == Clients.list_notification_records(user.id)
    end
  end

  ###########
  # Session #
  ###########

  describe "login/1" do
    test "with valid user_id creates a session" do
      user = insert(:user)
      assert {:ok, %Session{} = session} = Clients.login(%{user_id: user.id})
      assert session.user_id == user.id
    end

    test "raises error with invalid user_id" do
      assert_raise Ecto.ConstraintError, fn -> Clients.login(%{user_id: 0}) end
    end
  end

  describe "get_session_by_token/1" do
    test "reuturns a session when valid token is passed" do
      session = insert(:session)
      assert %Session{} = new_session = Clients.get_session_by_token(session.token)

      assert new_session.id == session.id
      assert new_session.token == session.token
      assert new_session.user_id == session.user_id
    end

    test "returns nil if invalid token is passed" do
      assert nil == Clients.get_session_by_token("abc")
    end
  end

  ######################
  # NotificationRecord #
  ######################

  describe "create_notification_record/1" do
    @valid_nickname Faker.Name.name
    @valid_email Faker.Internet.email

    test "with valid params creates a notification record" do
      user = insert(:user)
      assert {:ok, %NotificationRecord{} = record} = Clients.create_notification_record(%{user_id: user.id, nickname: @valid_nickname, email: @valid_email})

      assert record.email == @valid_email
      assert record.nickname == @valid_nickname
      assert record.user_id == user.id
      assert record.threshold == 0
      assert record.role == nil
    end

    test "with invalid params returns error and changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Clients.create_notification_record(%{user_id: nil, nickname: nil, email: nil})
      assert changeset.errors[:nickname] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:user_id] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:email] == {"can't be blank", [validation: :required]}
    end

    test "will associate with correct user" do
      user = insert(:user)
      {:ok, record} = Clients.create_notification_record(%{user_id: user.id, nickname: @valid_nickname, email: @valid_email})
      assert user == Clients.get_user!(record.user_id)
    end
  end

  describe "list_notification_records/1" do
    test "with valid user_id returns all notification records for a given user" do
      user = insert(:user)
      known_records = insert_list(5, :notification_record, user: user)
      insert_list(2, :notification_record)

      results = Clients.list_notification_records(user.id)
      assert known_records |> length == results |> length
    end

    test "with invalid user_id raises an error" do
      user = insert(:user)
      insert_list(5, :notification_record)

      assert_raise Ecto.Query.CastError, fn -> Clients.list_notification_records(user) end
    end

    test "returns empty list if no results" do
      user = insert(:user)
      insert_list(5, :notification_record)

      results = Clients.list_notification_records(user.id)
      assert results == []
    end
  end

  describe "get_notification_record!/1" do
    test "with a valid id returns the given notification record" do
      user = insert(:user)
      record = insert(:notification_record, user: user)

      result = Clients.get_notification_record!(record.id, user.id)

      assert result.user_id == record.user_id
      assert result.email == record.email
      assert result.nickname == record.nickname
      assert result.role == record.role
      assert result.id == record.id
    end

    test "with an invalid id will raise an error" do
      user = insert(:user)
      insert(:notification_record, user: user)

      result = Clients.get_notification_record!(1, user.id)
      assert result == nil
    end
  end

  describe "update_notification_record/2" do
    test "with a valid notification record and params the notification record is updated" do
      record = insert(:notification_record)
      new_email = "new@email.com"

      {:ok, result} = Clients.update_notification_record(record, %{email: new_email})

      assert result.email == new_email
      assert result.id == record.id
    end

    test "with invalid params returns error and changeset" do
      record = insert(:notification_record)

      assert {:error, %Ecto.Changeset{} = changeset} = Clients.update_notification_record(record, %{email: "dd2", user_id: "", nickname: nil})
      assert changeset.errors |> length == 3
    end
  end

  describe "delete_notification_record/1" do
    test "with a valid notification record the record will be destroyed" do
      record = insert(:notification_record)

      assert {:ok, %NotificationRecord{} = record} = Clients.delete_notification_record(record)
      assert !Clients.get_notification_record!(record.id, record.user_id)
    end
  end

  ############
  # Settings #
  ############

  describe "get_settings/1" do
    test "with valid user_id returns settings" do
      user = insert(:user)
      insert(:settings, user: user)

      assert %Settings{} = settings = Clients.get_settings!(user.id)
      assert settings.user_id == user.id
    end

    test "with invalid user_id raises error" do
      assert_raise Ecto.NoResultsError, fn -> Clients.get_settings!(0) end
    end
  end

  describe "create_settings/1" do
    test "with valid data creates settings" do
      user = insert(:user)
      assert {:ok, %Settings{} = settings} = Clients.create_settings(%{user_id: user.id})
      assert settings.user_id == user.id
      assert settings.global_threshold == 0
    end

    test "can only create one settings per user" do
      user = insert(:user)
      assert {:ok, %Settings{} = _} = Clients.create_settings(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{} = changeset} = Clients.create_settings(%{user_id: user.id})
      assert changeset.errors[:user_id] == {"has already been taken", []}
    end

    test "cannot create settings without user_id" do
      assert {:error, %Ecto.Changeset{} = changeset} = Clients.create_settings(%{})
      assert changeset.errors[:user_id] == {"can't be blank", [validation: :required]}
    end
  end

  describe "update_settings/2" do
    test "with valid user_id and attributes updates settings" do
      user = insert(:user)
      insert(:settings, user: user)
      new_threshold = 50

      assert {:ok, %Settings{} = settings} = Clients.update_settings(user.id, %{global_threshold: new_threshold})
      assert settings.user_id == user.id
      assert settings.global_threshold == new_threshold
    end

    test "with invalid user_id and attributes will raise NoResultsError" do
      insert(:settings)
      new_threshold = 50

      assert_raise Ecto.NoResultsError, fn -> Clients.update_settings(0, %{global_threshold: new_threshold}) end
    end

    test "with valid user_id and invalid attributes will return changeset with errors" do
      user = insert(:user)
      insert(:settings, user: user)

      assert {:error, %Ecto.Changeset{} = changeset} = Clients.update_settings(user.id, %{global_threshold: "hello"})
      assert changeset.errors[:global_threshold] == {"is invalid", [type: :integer, validation: :cast]}
    end
  end

  ##############
  # Changesets #
  ##############

  describe "change_user/1" do
    test "returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Clients.change_user(user)
    end
  end

  describe "register_user/1" do
    test "returns a registration changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Clients.register_user(user)
    end
  end

  describe "register_session/1" do
    test "returns a registration session changeset" do
      session = insert(:session)
      assert %Ecto.Changeset{} = Clients.register_session(session)
    end
  end
end
