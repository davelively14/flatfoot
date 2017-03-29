defmodule Flatfoot.ClientsTest do
  use Flatfoot.DataCase

  alias Flatfoot.Clients
  alias Flatfoot.Clients.User

  @create_attrs %{email: "some email", password_hash: "some password_hash", username: "some username"}
  @update_attrs %{email: "some updated email", password_hash: "some updated password_hash", username: "some updated username"}
  @invalid_attrs %{email: nil, password_hash: nil, username: nil}

  def fixture(:user, attrs \\ @create_attrs) do
    {:ok, user} = Clients.create_user(attrs)
    user
  end

  test "list_users/1 returns all users" do
    user = fixture(:user)
    assert Clients.list_users() == [user]
  end

  test "get_user! returns the user with given id" do
    user = fixture(:user)
    assert Clients.get_user!(user.id) == user
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Clients.create_user(@create_attrs)
    assert user.email == "some email"
    assert user.password_hash == "some password_hash"
    assert user.username == "some username"
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Clients.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = fixture(:user)
    assert {:ok, user} = Clients.update_user(user, @update_attrs)
    assert %User{} = user
    assert user.email == "some updated email"
    assert user.password_hash == "some updated password_hash"
    assert user.username == "some updated username"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = fixture(:user)
    assert {:error, %Ecto.Changeset{}} = Clients.update_user(user, @invalid_attrs)
    assert user == Clients.get_user!(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = fixture(:user)
    assert {:ok, %User{}} = Clients.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Clients.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = fixture(:user)
    assert %Ecto.Changeset{} = Clients.change_user(user)
  end
end
