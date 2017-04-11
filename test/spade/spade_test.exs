defmodule Flatfoot.SpadeTest do
  use Flatfoot.DataCase

  alias Flatfoot.{Spade}

  ###########
  # Backend #
  ###########

  describe "list_backends/0" do
    test "will return all backends" do
      backends = insert_list(3, :backend)
      results = Spade.list_backends()

      assert backends |> length == results |> length
    end

    test "will return the correct backends" do
      backend = insert(:backend)

      [result] = Spade.list_backends()
      assert result.id == backend.id
      assert result.name == backend.name
      assert result.url == backend.url

      assert_raise KeyError, fn -> result.name_snake end
      assert_raise KeyError, fn -> result.module end
    end

    test "will return empty list if no backends stored" do
      assert [] == Spade.list_backends()
    end
  end

  describe "get_backend!/1" do
    test "with valid id returns a backend" do
      backend = insert(:backend)
      result = Spade.get_backend!(backend.id)

      assert result.id == backend.id
      assert result.name == backend.name
      assert result.url == backend.url

      assert_raise KeyError, fn -> result.name_snake end
      assert_raise KeyError, fn -> result.module end
    end

    test "with invalid id raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_backend!(0) end
    end
  end

  ########
  # User #
  ########

  describe "get_user!/1" do
    test "with valid id returns a user" do
      user = insert(:user)
      result = Spade.get_user!(user.id)

      assert user.id == result.id
      assert user.username == result.username
      assert user.email == result.email

      assert_raise KeyError, fn -> result.password_hash end
    end

    test "with invalid id raises an error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_user!(0) end
    end
  end

  ##########
  # Target #
  ##########

  describe "create_target/1" do
    test "with valid attributes, creates target" do
      name = Faker.Name.name
      relationship = Faker.Team.creature
      user = insert(:user)

      {:ok, target} = Spade.create_target(%{name: name, relationship: relationship, user_id: user.id})
      assert name == target.name
      assert relationship == target.relationship
      assert user.id == target.user_id
    end

    test "with invalid attributes, will return changeset with errors" do
      {:error, changeset} = Spade.create_target(%{})

      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:user_id] == {"can't be blank", [validation: :required]}
    end
  end

  describe "list_targets/1" do
    test "with valid user_id, returns all targets for that user" do
      user = insert(:user)
      user_targets = insert(:target, user: user)
      insert_list(2, :target)

      results = Spade.list_targets(user.id)
      assert results |> length == 1
      assert user_targets.id == results |> List.first |> Map.get(:id)
    end

    test "returns empty list if no backends exist" do
      insert_list(3, :target)
      results = Spade.list_targets(1)
      assert [] == results
    end
  end

  describe "get_target!/1" do
    test "with valid id, returns a target" do
      target = insert(:target)

      result = Spade.get_target!(target.id)
      assert result.id == target.id
      assert result.name == target.name
    end

    test "with invalid id, raises an error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_target!(0) end
    end
  end

  describe "delete_target/1" do
    test "with valid id, deletes a target and returns the deleted target" do
      target = insert(:target)

      {:ok, result} = Spade.delete_target(target.id)
      assert result.id == target.id
      assert Spade.list_targets(target.user_id) == []
    end

    test "with invalid id, raises NoResultsError" do
      assert_raise Ecto.NoResultsError, fn -> Spade.delete_target(0) end
    end
  end

  describe "update_target/2" do
    test "with valid target_id and attributes, updates a target" do
      target = insert(:target)
      new_name = "New name"

      {:ok, result} = Spade.update_target(target.id, %{name: new_name})
      assert result.id == target.id
      assert result.name != target.name
      assert result.name == new_name
    end

    test "with invalid params, returns changeset with errors" do
      target = insert(:target)

      {:error, changeset} = Spade.update_target(target.id, %{name: nil})
      assert changeset.errors |> length == 1
      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
    end

    test "with invalid target_id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.update_target(0, %{name: "Hello"}) end
    end
  end

  ##################
  # Target Account #
  ##################

  describe "create_target_account/1" do
    test "with valid attributes, creates target account" do
      target = insert(:target)
      backend = insert(:backend)
      handle = Faker.Internet.user_name
      {:ok, result} = Spade.create_target_account(%{target_id: target.id, backend_id: backend.id, handle: handle})

      assert result.target_id == target.id
      assert result.backend_id == backend.id
      assert result.handle == handle
    end

    test "with invalid attributes, returns a changeset with errors" do
      {:error, changeset} = Spade.create_target_account(%{})

      assert changeset.errors[:target_id] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:backend_id] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:handle] == {"can't be blank", [validation: :required]}
    end
  end

  describe "list_target_accounts/1" do
    test "with valid target_id, returns a list of target accounts" do
      target = insert(:target)
      account = insert(:target_accounts, target: target)
      insert_list(2, :target_accounts)

      results = Spade.list_target_accounts(target.id)
      assert results |> length == 1
      assert account.id == results |> List.first |> Map.get(:id)
    end

    test "with non existant target_id returns empty list" do
      assert [] == Spade.list_target_accounts(0)
    end
  end
end
