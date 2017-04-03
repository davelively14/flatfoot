defmodule Flatfoot.ClientsTest do
  use Flatfoot.DataCase

  alias Flatfoot.{Clients, Clients.User, Clients.Session}

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

    test "deletes associated sessions" do
      user = insert(:user)
      session = insert(:session, user: user)

      assert session.id == Clients.get_session_by_token(session.token) |> Map.get(:id)
      assert {:ok, %User{}} = Clients.delete_user(user)
      assert nil == Clients.get_session_by_token(session.token)
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
