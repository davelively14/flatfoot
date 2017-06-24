defmodule Flatfoot.SpadeTest do
  use Flatfoot.DataCase

  alias Flatfoot.{Spade, Spade.Suspect, Spade.SuspectAccount, Spade.WardResult}

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
    end

    test "with invalid id raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_backend!(0) end
    end
  end

  describe "get_backend/1" do
    test "with valid id returns a backend" do
      backend = insert(:backend)
      result = Spade.get_backend(backend.id)

      assert result.id == backend.id
      assert result.name == backend.name
      assert result.url == backend.url
    end

    test "with invalid id, returns nil" do
      assert nil == Spade.get_backend(0)
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

  describe "get_user_preload/1" do
    test "with valid id returns a user" do
      user = insert(:user)
      backend = insert(:backend)

      watchlist = insert(:watchlist, user: user)
      suspect = insert(:suspect, watchlist: watchlist)
      suspect_account = insert(:suspect_account, suspect: suspect, backend: backend)

      ward = insert(:ward, user: user)
      ward_account = insert(:ward_account, ward: ward)

      result = Spade.get_user_preload(user.id)
      assert result.id == user.id

      [result_wards] = result.wards
      assert result_wards.id == ward.id

      [result_accounts] = result_wards.ward_accounts
      assert result_accounts.id == ward_account.id
      assert %Flatfoot.Spade.Backend{} = result_accounts.backend

      [result_watchlists] = result.watchlists
      assert result_watchlists.id == watchlist.id

      [result_suspects] = result_watchlists.suspects
      assert result_suspects.id == suspect.id

      [result_accounts] = result_suspects.suspect_accounts
      assert result_accounts.id == suspect_account.id
      assert %Flatfoot.Spade.Backend{} = result_accounts.backend
    end

    test "with invalid id returns nil" do
      refute Spade.get_user_preload(0)
    end
  end

  describe "get_user_by_token/1" do
    test "with valid token, returns user" do
      user = insert(:user)
      session = insert(:session, user: user)

      result = Spade.get_user_by_token(session.token)
      assert result.id == user.id
      assert result.username == user.username
    end

    test "with invalid token, returns nil" do
      assert {:error, "Session does not exist. Please use valid token."} == Spade.get_user_by_token("hello")
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

  describe "list_wards_preload/1" do
    test "with valid user_id, returns all associated wards and preloaded associations" do
      user = insert(:user)
      ward = insert(:ward, user: user)
      ward_account = insert(:ward_account, ward: ward)

      [result] = Spade.list_wards_preload(user.id)
      assert result.id == ward.id

      [result_accounts] = result.ward_accounts
      assert result_accounts.id == ward_account.id
      assert %Flatfoot.Spade.Backend{} = result_accounts.backend
    end

    test "with watchlist_id and no suspects, returns empty list" do
      user = insert(:user)
      insert_list(3, :ward)

      assert [] = Spade.list_suspects_preload(user.id)
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

  describe "get_ward_preload/1" do
    test "with valid id, returns a ward with all preloads" do
      ward = insert(:ward)
      ward_account = insert(:ward_account, ward: ward)

      result = Spade.get_ward_preload(ward.id)
      assert result.id == ward.id

      [result_accounts] = result.ward_accounts
      assert result_accounts.id == ward_account.id
      assert %Flatfoot.Spade.Backend{} = result_accounts.backend
    end

    test "with invalid id, returns nil" do
      assert nil == Spade.get_ward_preload(0)
    end
  end

  describe "get_ward_preload_with_results/1" do
    test "with valid id, returns a ward with all preloads" do
      ward = insert(:ward)
      ward_account = insert(:ward_account, ward: ward)
      ward_result = insert(:ward_result, ward_account: ward_account)

      resp = Spade.get_ward_preload_with_results(ward.id)
      assert resp.id == ward.id

      [resp_account] = resp.ward_accounts
      assert resp_account.id == ward_account.id
      assert %Flatfoot.Spade.Backend{} = resp_account.backend

      [resp_result] = resp_account.ward_results
      assert resp_result.id == ward_result.id
    end

    test "with invalid id, returns nil" do
      assert nil == Spade.get_ward_preload_with_results(0)
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

    test "with valid id, deletes all associated content" do
      ward = insert(:ward)
      ward_account = insert(:ward_account, ward: ward)
      ward_result = insert(:ward_result, ward_account: ward_account)

      {:ok, result} = Spade.delete_ward(ward.id)
      assert result.id == ward.id
      refute Spade.get_ward(ward.id)
      refute Spade.get_ward_account(ward_account.id)
      refute Spade.get_ward_result(ward_result.id)
    end
  end

  describe "update_ward!/2" do
    test "with valid ward_id and attributes, updates a ward" do
      ward = insert(:ward)
      new_name = "New name"

      {:ok, result} = Spade.update_ward!(ward.id, %{name: new_name})
      assert result.id == ward.id
      assert result.name != ward.name
      assert result.name == new_name
    end

    test "does not update associations" do
      ward = insert(:ward)
      new_name = "new name"

      {:ok, result} = Spade.update_ward!(ward.id, %{name: new_name, user_id: 0})
      assert result.id == ward.id
      assert result.name == new_name
      assert result.user_id == ward.user_id != 0
    end

    test "with invalid params, returns changeset with errors" do
      ward = insert(:ward)

      {:error, changeset} = Spade.update_ward!(ward.id, %{name: nil})
      assert changeset.errors |> length == 1
      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
    end

    test "with invalid ward_id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.update_ward!(0, %{name: "Hello"}) end
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

    test "with invalid ward_id, returns nil" do
      assert nil == Spade.update_ward(0, %{name: "Hello"})
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

  describe "get_ward_account/1" do
    test "with valid ward_account_id, returns a single ward account" do
      account = insert(:ward_account)

      result = Spade.get_ward_account(account.id)
      assert result.id == account.id
      assert result.handle == account.handle
      assert result.ward_id == account.ward_id
      assert result.backend_id == account.backend_id
    end

    test "with invalid ward_account_id, raises error" do
      assert nil == Spade.get_ward_account(0)
    end
  end

  describe "get_ward_account_preload!/1" do
    test "with valid ward_account_id, returns a single ward account with backload preloaded" do
      backend = insert(:backend)
      account = insert(:ward_account, backend: backend)

      result = Spade.get_ward_account_preload!(account.id)
      assert account.id == result.id
      assert result.backend.id == backend.id
      assert result.backend.name == backend.name
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

    test "with valid id, deletes a ward account and children results, then returns that deleted account" do
      account = insert(:ward_account)
      insert(:ward_result, ward_account: account)

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

    test "does not update ward association" do
      account = insert(:ward_account)
      new_handle = "@things"

      {:ok, result} = Spade.update_ward_account(account.id, %{handle: new_handle, ward_id: 0})
      assert result.id == account.id
      assert result.handle == new_handle
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

  describe "list_watchlist_preload/1" do
    test "with valid user id, loads watchlist and all preloads" do
      user = insert(:user)
      watchlist = insert(:watchlist, user: user)
      suspect = insert(:suspect, watchlist: watchlist)
      suspect_account = insert(:suspect_account, suspect: suspect)

      [result] = Spade.list_watchlists_preload(user.id)
      assert result.id == watchlist.id

      [result_suspects] = result.suspects
      assert result_suspects.id == suspect.id

      [result_accounts] = result_suspects.suspect_accounts
      assert result_accounts.id == suspect_account.id
      assert %Flatfoot.Spade.Backend{} = result_accounts.backend
    end

    test "with user_id with no watchlists, returns empty list" do
      user = insert(:user)
      insert_list(3, :watchlist)

      assert [] == Spade.list_watchlists_preload(user.id)
    end
  end

  describe "get_watchlist!/1" do
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

  describe "get_watchlist_preload!/1" do
    test "with valid id, returns a watchlist" do
      watchlist = insert(:watchlist)
      suspect = insert(:suspect, watchlist: watchlist)
      suspect_account = insert(:suspect_account, suspect: suspect)

      result = Spade.get_watchlist_preload!(watchlist.id)
      assert result.id == watchlist.id

      [result_suspects] = result.suspects
      assert result_suspects.id == suspect.id

      [result_accounts] = result_suspects.suspect_accounts
      assert result_accounts.id == suspect_account.id
      assert %Flatfoot.Spade.Backend{} = result_accounts.backend
    end

    test "with invalid id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_watchlist_preload!(0) end
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
      watchlist = insert(:watchlist)
      attrs = %{name: Faker.Name.name, category: Faker.Lorem.word, notes: Faker.Lorem.Shakespeare.hamlet, active: true, watchlist_id: watchlist.id}

      {:ok, result} = Spade.create_suspect(attrs)
      assert result.name == attrs.name
      assert result.category == attrs.category
      assert result.notes == attrs.notes
      assert result.active == attrs.active
      assert result.watchlist_id == attrs.watchlist_id
    end

    test "with invalid attributes, will return a changeset with errors" do
      {:error, changeset} = Spade.create_suspect(%{})

      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:watchlist_id] == {"can't be blank", [validation: :required]}
    end
  end

  describe "list_suspects/1" do
    test "with valid watchlist_id, returns all associated suspects" do
      watchlist = insert(:watchlist)
      suspect = insert(:suspect, watchlist: watchlist)
      insert_list(3, :suspect)

      results = Spade.list_suspects(watchlist.id)
      assert results |> length == 1
      assert results |> List.first |> Map.get(:id) == suspect.id
    end

    test "with watchlist_id with no suspects, returns empty list" do
      watchlist = insert(:watchlist)
      insert_list(3, :suspect)

      assert [] == Spade.list_suspects(watchlist.id)
    end
  end

  describe "list_suspects_preload/1" do
    test "with valid watchlist_id, returns all associated suspects and preloaded associations" do
      watchlist = insert(:watchlist)
      suspect = insert(:suspect, watchlist: watchlist)
      suspect_account = insert(:suspect_account, suspect: suspect)

      [result] = Spade.list_suspects_preload(watchlist.id)
      assert result.id == suspect.id

      [result_accounts] = result.suspect_accounts
      assert result_accounts.id == suspect_account.id
      assert %Flatfoot.Spade.Backend{} = result_accounts.backend
    end

    test "with watchlist_id and no suspects, returns empty list" do
      watchlist = insert(:watchlist)
      insert_list(3, :suspect)

      assert [] = Spade.list_suspects_preload(watchlist.id)
    end
  end

  describe "get_suspect!/1" do
    test "with valid id, will return a single suspect" do
      suspect = insert(:suspect)

      assert %Suspect{} = result = Spade.get_suspect!(suspect.id)
      assert result.id == suspect.id
      assert result.name == suspect.name
    end

    test "with invalid id, will raise error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_suspect!(0) end
    end
  end

  describe "get_suspect_preload!/1" do
    test "with valid id, returns a single suspect and preloaded associations" do
      suspect = insert(:suspect)
      suspect_account = insert(:suspect_account, suspect: suspect)

      result = Spade.get_suspect_preload!(suspect.id)
      assert result.id == suspect.id

      [result_accounts] = result.suspect_accounts
      assert result_accounts.id == suspect_account.id
      assert %Flatfoot.Spade.Backend{} = result_accounts.backend
    end

    test "with invalid id, will raise error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_suspect_preload!(0) end
    end
  end

  describe "delete_suspect/1" do
    test "with valid id, deletes and returns a suspect" do
      suspect = insert(:suspect)

      assert {:ok, %Suspect{} = result} = Spade.delete_suspect(suspect.id)
      assert result.id == suspect.id

      assert_raise Ecto.NoResultsError, fn -> Spade.get_suspect!(suspect.id) end
    end

    test "with invalid id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.delete_suspect(0) end
    end
  end

  describe "update_suspect/1" do
    test "with valid id and attrs, updates a suspect" do
      suspect = insert(:suspect)
      new_name = "New name"

      assert {:ok, %Suspect{} = result} = Spade.update_suspect(suspect.id, %{name: new_name})
      assert suspect.id == result.id
      assert suspect.name != result.name
      assert new_name == result.name
    end

    test "with valid id and attrs, ignores association change, updates a suspect" do
      suspect = insert(:suspect)
      new_name = "New name"
      new_watchlist_id = 0

      assert {:ok, %Suspect{} = result} = Spade.update_suspect(suspect.id, %{name: new_name, watchlist_id: new_watchlist_id})
      assert suspect.id == result.id
      assert suspect.name != result.name
      assert new_name == result.name
      assert suspect.watchlist_id == result.watchlist_id
      assert new_watchlist_id != result.watchlist_id
    end

    test "with invalid id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.update_suspect(0, %{}) end
    end
  end

  ###################
  # Suspect Account #
  ###################

  describe "create_suspect_account/1" do
    test "with valid attributes, will create a suspect account" do
      suspect = insert(:suspect)
      backend = insert(:backend)
      attrs = %{handle: Faker.Internet.user_name, backend_id: backend.id, suspect_id: suspect.id}

      {:ok, result} = Spade.create_suspect_account(attrs)
      assert result.handle == attrs.handle
      assert result.backend_id == attrs.backend_id
      assert result.suspect_id == attrs.suspect_id
    end

    test "with invalid attributes, will return a changeset with errors" do
      {:error, changeset} = Spade.create_suspect_account(%{})

      assert changeset.errors[:handle] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:suspect_id] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:backend_id] == {"can't be blank", [validation: :required]}
    end
  end

  describe "list_suspect_accounts/1" do
    test "with valid suspect id, returns all associated suspect accounts" do
      suspect = insert(:suspect)
      account = insert(:suspect_account, suspect: suspect)
      insert_list(3, :suspect_account)

      results = Spade.list_suspect_accounts(suspect.id)
      assert results |> length == 1
      assert results |> List.first |> Map.get(:id) == account.id
    end

    test "with suspect id with no suspects, returns empty list" do
      suspect = insert(:suspect)
      insert_list(3, :suspect_account)

      assert [] == Spade.list_suspect_accounts(suspect.id)
    end
  end

  describe "get_suspect_account!/1" do
    test "with valid id, will return a single suspect" do
      suspect_account = insert(:suspect_account)

      assert %SuspectAccount{} = result = Spade.get_suspect_account!(suspect_account.id)
      assert result.id == suspect_account.id
      assert result.handle == suspect_account.handle
    end

    test "with invalid id, will raise error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_suspect_account!(0) end
    end
  end

  describe "delete_suspect_account/1" do
    test "with valid id, deletes and returns a suspect account" do
      suspect_account = insert(:suspect_account)

      assert {:ok, %SuspectAccount{} = result} = Spade.delete_suspect_account(suspect_account.id)
      assert result.id == suspect_account.id

      assert_raise Ecto.NoResultsError, fn -> Spade.get_suspect_account!(suspect_account.id) end
    end

    test "with invalid id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.delete_suspect_account(0) end
    end
  end

  describe "update_suspect_account/1" do
    test "with valid id and attrs, updates a suspect_account" do
      suspect_account = insert(:suspect_account)
      new_handle = "New name"

      assert {:ok, %SuspectAccount{} = result} = Spade.update_suspect_account(suspect_account.id, %{handle: new_handle})
      assert suspect_account.id == result.id
      assert suspect_account.handle != result.handle
      assert new_handle == result.handle
    end

    test "with valid id and attrs, ignores association changes, updates a suspect_account" do
      suspect_account = insert(:suspect_account)
      new_handle = "New name"
      new_backend_id = 0
      new_suspect_id = 0

      assert {:ok, %SuspectAccount{} = result} = Spade.update_suspect_account(suspect_account.id, %{handle: new_handle, backend_id: new_backend_id, suspect_id: new_suspect_id})
      assert suspect_account.id == result.id
      assert suspect_account.handle != result.handle
      assert new_handle == result.handle
      assert suspect_account.backend_id == result.backend_id
      assert new_backend_id != result.backend_id
      assert suspect_account.suspect_id == result.suspect_id
      assert new_suspect_id != result.suspect_id
    end

    test "with invalid id, raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.update_suspect_account(0, %{}) end
    end
  end

  ###############
  # Ward Result #
  ###############

  describe "list_ward_results/1" do
    test "with valid ward_account id, returns all associated ward_account results" do
      ward_account = insert(:ward_account)
      ward_result = insert(:ward_result, ward_account: ward_account)
      insert_list(3, :ward_result)

      assert [result] = Spade.list_ward_results(ward_account.id)
      assert result.id == ward_result.id
    end

    test "with valid ward_account id and as_of date, returns expected number of results" do
      ward_account = insert(:ward_account)
      ward_result = insert(:ward_result, ward_account: ward_account)

      assert [] == Spade.list_ward_results(ward_account.id, "2200-01-01")
      assert [result] = Spade.list_ward_results(ward_account.id, "1999-01-01")
      assert result.id == ward_result.id
    end

    test "with ward_account id with no ward_account results, returns empty list" do
      ward_account = insert(:ward_account)
      insert_list(3, :ward_result)

      assert [] == Spade.list_ward_results(ward_account.id)
    end
  end

  describe "list_ward_results_by_user/1" do
    test "with valid token, returns results for all associated ward_accounts in correct order" do
      user = insert(:user)
      session = insert(:session, user: user)
      ward = insert(:ward, user: user)
      ward_account1 = insert(:ward_account, ward: ward)
      ward_account2 = insert(:ward_account, ward: ward)
      ward_result1 = insert(:ward_result, ward_account: ward_account2, timestamp: Ecto.DateTime.cast({{2016, 1, 1}, {0,0,0}}) |> elem(1), rating: 100)
      insert(:ward_result, ward_account: ward_account1, timestamp: Ecto.DateTime.cast({{2017, 1, 1}, {0,0,0}}) |> elem(1), rating: 50)
      ward_result3 = insert(:ward_result, ward_account: ward_account1, timestamp: Ecto.DateTime.cast({{2017, 1, 1}, {0,0,0}}) |> elem(1), rating: 0)

      result = Spade.list_ward_results_by_user(session.token)
      assert result |> List.first |> Map.get(:id) == ward_result1.id
      assert result |> List.last |> Map.get(:id) == ward_result3.id
    end

    test "with valid token and as_of date, returns correct results" do
      user = insert(:user)
      session = insert(:session, user: user)
      ward = insert(:ward, user: user)
      ward_account = insert(:ward_account, ward: ward)
      ward_result = insert(:ward_result, ward_account: ward_account)

      assert [] == Spade.list_ward_results_by_user(session.token, "2200-01-01")
      assert [result] = Spade.list_ward_results_by_user(session.token, "1999-01-01")
      assert result.id == ward_result.id
    end

    test "with valid token and invalid as_of date, returns an error" do
      user = insert(:user)
      session = insert(:session, user: user)
      ward = insert(:ward, user: user)
      ward_account = insert(:ward_account, ward: ward)
      insert(:ward_result, ward_account: ward_account)

      assert_raise ArgumentError, fn -> Spade.list_ward_results_by_user(session.token, "bob") end
    end

    test "with invalid token, raises error" do
      assert_raise BadMapError, fn -> Spade.list_ward_results_by_user("hello") end
    end
  end

  describe "get_ward_result/1" do
    test "with valid id, will return a single ward result" do
      ward_result = insert(:ward_result)

      assert %WardResult{} = result = Spade.get_ward_result(ward_result.id)
      assert result.id == ward_result.id
      assert result.ward_account_id == ward_result.ward_account_id
    end

    test "with invalid id, will return nil" do
      assert nil == Spade.get_ward_result(0)
    end
  end

  describe "delete_ward_result/1" do
    test "with valid id, deletes and returns a ward result" do
      ward_result = insert(:ward_result)

      assert {:ok, %WardResult{} = result} = Spade.delete_ward_result(ward_result.id)
      assert result.id == ward_result.id

      assert_raise Ecto.NoResultsError, fn -> Spade.get_ward_account!(ward_result.id) end
    end

    test "with invalid id, raises error" do
      assert_raise FunctionClauseError, fn -> Spade.delete_ward_result(0) end
    end
  end
end
