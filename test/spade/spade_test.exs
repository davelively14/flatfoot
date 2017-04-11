defmodule Flatfoot.SpadeTest do
  use Flatfoot.DataCase

  alias Flatfoot.{Spade}

  ###########
  # Backend #
  ###########

  describe "list_backends/0" do
    test "will return all backends" do
      backends = insert_list(3, :archer_backend)
      results = Spade.list_backends()

      assert backends |> length == results |> length
    end

    test "will return the correct backends" do
      backend = insert(:archer_backend)

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
      backend = insert(:archer_backend)
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
end
