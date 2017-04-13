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

  ########
  # Ward #
  ########

  describe "create_ward/1" do
    test "with valid attributes, creates ward" do
      name = Faker.Name.name
      relationship = Faker.Team.creature
      user = insert(:user)

      {:ok, ward} = Spade.create_ward(%{name: name, relationship: relationship, user_id: user.id})
      assert name == ward.name
      assert relationship == ward.relationship
      assert user.id == ward.user_id
    end

    test "with invalid attributes, will return changeset with errors" do
      {:error, changeset} = Spade.create_ward(%{})

      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:user_id] == {"can't be blank", [validation: :required]}
    end
  end

  describe "list_wards/1" do
    test "with valid user_id, returns all wards for that user" do
      user = insert(:user)
      user_wards = insert(:ward, user: user)
      insert_list(2, :ward)

      results = Spade.list_wards(user.id)
      assert results |> length == 1
      assert user_wards.id == results |> List.first |> Map.get(:id)
    end

    test "returns empty list if no backends exist" do
      insert_list(3, :ward)
      results = Spade.list_wards(1)
      assert [] == results
    end
  end

  describe "get_ward!/1" do
    test "with valid id, returns a ward" do
      ward = insert(:ward)

      result = Spade.get_ward!(ward.id)
      assert result.id == ward.id
      assert result.name == ward.name
    end

    test "with invalid id, raises an error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_ward!(0) end
    end
  end

  describe "delete_ward/1" do
    test "with valid id, deletes a ward and returns the deleted ward" do
      ward = insert(:ward)

      {:ok, result} = Spade.delete_ward(ward.id)
      assert result.id == ward.id
      assert_raise Ecto.NoResultsError, fn -> Spade.get_ward!(ward.id) end
    end

    test "with invalid id, raises NoResultsError" do
      assert_raise Ecto.NoResultsError, fn -> Spade.delete_ward(0) end
    end
  end

  describe "update_ward/2" do
    test "with valid ward_id and attributes, updates a ward" do
      ward = insert(:ward)
      new_name = "New name"

      {:ok, result} = Spade.update_ward(ward.id, %{name: new_name})
      assert result.id == ward.id
      assert result.name != ward.name
      assert result.name == new_name
    end

    test "does not update associations" do
      ward = insert(:ward)
      new_name = "new name"

      {:ok, result} = Spade.update_ward(ward.id, %{name: new_name, user_id: 0})
      assert result.id == ward.id
      assert result.name == new_name
      assert result.user_id == ward.user_id != 0
    end

    test "with invalid params, returns changeset with errors" do
      ward = insert(:ward)

      {:error, changeset} = Spade.update_ward(ward.id, %{name: nil})
      assert changeset.errors |> length == 1
      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
    end

    test "with invalid ward_id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.update_ward(0, %{name: "Hello"}) end
    end
  end

  ################
  # Ward Account #
  ################

  describe "create_ward_account/1" do
    test "with valid attributes, creates ward account" do
      ward = insert(:ward)
      backend = insert(:backend)
      handle = Faker.Internet.user_name
      {:ok, result} = Spade.create_ward_account(%{ward_id: ward.id, backend_id: backend.id, handle: handle})

      assert result.ward_id == ward.id
      assert result.backend_id == backend.id
      assert result.handle == handle
    end

    test "with invalid attributes, returns a changeset with errors" do
      {:error, changeset} = Spade.create_ward_account(%{})

      assert changeset.errors[:ward_id] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:backend_id] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:handle] == {"can't be blank", [validation: :required]}
    end
  end

  describe "list_ward_accounts/1" do
    test "with valid ward_id, returns a list of ward accounts" do
      ward = insert(:ward)
      account = insert(:ward_account, ward: ward)
      insert_list(2, :ward_account)

      results = Spade.list_ward_accounts(ward.id)
      assert results |> length == 1
      assert account.id == results |> List.first |> Map.get(:id)
    end

    test "with non existant ward_id returns empty list" do
      assert [] == Spade.list_ward_accounts(0)
    end
  end

  describe "get_ward_account!/1" do
    test "with valid ward_account_id, returns a single ward account" do
      account = insert(:ward_account)

      result = Spade.get_ward_account!(account.id)
      assert result.id == account.id
      assert result.handle == account.handle
      assert result.ward_id == account.ward_id
      assert result.backend_id == account.backend_id
    end

    test "with invalid ward_account_id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_ward_account!(0) end
    end
  end

  describe "delete_ward_account/1" do
    test "with valid id, deletes a ward account and returns that deleted account" do
      account = insert(:ward_account)

      {:ok, result} = Spade.delete_ward_account(account.id)
      assert result.id == account.id
      assert_raise Ecto.NoResultsError, fn -> Spade.get_ward_account!(account.id) end
    end

    test "with invalid id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.delete_ward_account(0) end
    end
  end

  describe "update_ward_account/2" do
    test "with valid ward_account_id and attributes, updates ward_account" do
      account = insert(:ward_account)
      new_handle = "@things"

      {:ok, result} = Spade.update_ward_account(account.id, %{handle: new_handle})
      assert result.id == account.id
      assert result.handle == new_handle
    end

    test "does not update associations" do
      account = insert(:ward_account)
      new_handle = "@things"

      {:ok, result} = Spade.update_ward_account(account.id, %{handle: new_handle, backend_id: 0, ward_id: 0})
      assert result.id == account.id
      assert result.handle == new_handle
      assert result.backend_id == account.backend_id != 0
      assert result.ward_id == account.ward_id != 0
    end

    test "with invalid params, returns changeset with error" do
      account = insert(:ward_account)

      {:error, changeset} = Spade.update_ward_account(account.id, %{handle: nil})
      assert changeset.errors[:handle] == {"can't be blank", [validation: :required]}
    end

    test "with invalid id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.update_ward_account(0, %{}) end
    end
  end

  #############
  # Watchlist #
  #############

  describe "create_watchlist/1" do
    test "with valid attributes, creates a watchlist" do
      user = insert(:user)
      name = Faker.Name.name

      {:ok, watchlist} = Spade.create_watchlist(%{user_id: user.id, name: name})
      assert watchlist.name == name
      assert watchlist.user_id == user.id
    end

    test "with invalid attributes, returns a changeset with errors" do
      {:error, changeset} = Spade.create_watchlist(%{})
      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:user_id] == {"can't be blank", [validation: :required]}
    end
  end

  describe "list_watchlists/1" do
    test "with valid user_id, returns list of watchlists" do
      user = insert(:user)
      watchlist = insert(:watchlist, user: user)
      insert_list(3, :watchlist)

      results = Spade.list_watchlists(user.id)
      assert results |> length == 1
      assert watchlist.id == results |> List.first |> Map.get(:id)
    end

    test "with user_id with no watchlists, returns empty list" do
      user = insert(:user)
      insert_list(3, :watchlist)

      assert [] == Spade.list_watchlists(user.id)
    end
  end

  describe "get_watchlist/1" do
    test "with valid id, returns a watchlist" do
      watchlist = insert(:watchlist)

      result = Spade.get_watchlist!(watchlist.id)
      assert result.id == watchlist.id
      assert result.name == watchlist.name
    end

    test "with invalid id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_watchlist!(0) end
    end
  end

  describe "delete_watchlist/1" do
    test "with valid id, deletes watchlist" do
      watchlist = insert(:watchlist)

      {:ok, result} = Spade.delete_watchlist(watchlist.id)
      assert result.id == watchlist.id
      assert_raise Ecto.NoResultsError, fn -> Spade.get_watchlist!(watchlist.id) end
    end

    test "with invalid id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.delete_watchlist(0) end
    end
  end

  describe "update_watchlist/2" do
    test "with valid id and attributes, updates watchlist" do
      watchlist = insert(:watchlist)
      new_name = "New name"

      {:ok, result} = Spade.update_watchlist(watchlist.id, %{name: new_name})
      assert result.id == watchlist.id
      assert result.name == new_name
    end

    test "with invalid id and valid attributes, raises error" do
      new_name = "New name"
      assert_raise Ecto.NoResultsError, fn -> Spade.update_watchlist(0, %{name: new_name}) end
    end

    test "with valid id and invalid attributes, returns changeset with errors" do
      watchlist = insert(:watchlist)
      {:error, changeset} = Spade.update_watchlist(watchlist.id, %{name: ""})
      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
    end

    test "cannot alter associations" do
      watchlist = insert(:watchlist)
      {:ok, result} = Spade.update_watchlist(watchlist.id, %{user_id: 0})
      assert watchlist.id == result.id != 0
    end
  end

  ###########
  # Suspect #
  ###########

  describe "create_suspect/1" do
    test "with valid attributes, will create a suspect" do
      user = insert(:user)
      attrs = %{name: Faker.Name.name, category: Faker.Lorem.word, notes: Faker.Lorem.Shakespeare.hamlet, active: true, user_id: user.id}

      {:ok, result} = Spade.create_suspect(attrs)
      assert result.name == attrs.name
      assert result.category == attrs.category
      assert result.notes == attrs.notes
      assert result.active == attrs.active
      assert result.user_id == attrs.user_id
    end

    test "with invalid attributes, will return a changeset with errors" do
      {:error, changeset} = Spade.create_suspect(%{})

      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:user_id] == {"can't be blank", [validation: :required]}
    end
  end
end
