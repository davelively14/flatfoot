defmodule FlatfootWeb.SpadeChannelTest do
  use FlatfootWeb.ChannelCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Flatfoot.Spade
  alias FlatfootWeb.SpadeChannel

  setup config do
    ExVCR.Config.cassette_library_dir("test/support/vcr_cassettes")
    user = insert(:user)
    token = insert(:session, user: user) |> Map.get(:token)

    cond do
      config[:full_spec] ->
        {:ok, watchlist_data} = generate_and_return_watchlist_data(user)
        {:ok, ward_data} = generate_and_return_ward_data(user)
        user = Spade.get_user_preload(user.id)
        {:ok, resp, socket} = socket("", %{user_id: user.id}) |> subscribe_and_join(SpadeChannel, "spade:#{user.id}")
        {:ok, %{user: user, resp: resp, socket: socket, ward_data: ward_data, watchlist_data: watchlist_data, token: token}}

      config[:user_preloaded] ->
        generate_and_return_watchlist_data(user)
        generate_and_return_ward_data(user)
        user = Spade.get_user_preload(user.id)
        {:ok, %{user: user, token: token}}

      config[:socket_only] ->
        {:ok, _resp, socket} = socket("", %{user_id: user.id}) |> subscribe_and_join(SpadeChannel, "spade:#{user.id}")
        {:ok, %{socket: socket}}

      config[:empty_user_only] ->
        {:ok, %{user: user, token: token}}

      true ->
        :ok
    end
  end

  describe "join" do
    @tag :user_preloaded
    test "will return response and socket", %{user: user} do
      {:ok, resp, socket} = socket("", %{user_id: user.id}) |> subscribe_and_join(SpadeChannel, "spade:#{user.id}")

      assert resp == Phoenix.View.render(FlatfootWeb.Spade.UserView, "user.json", %{user: user})
      assert socket.channel == FlatfootWeb.SpadeChannel
      assert socket.assigns.user_id == user.id
      leave socket
    end

    test "will return error if no valid user given" do
      assert {:error, "User does not exist"} == subscribe_and_join(socket("", %{user_id: 0}), SpadeChannel, "spade:#{0}")
    end

    @tag :user_preloaded
    test "will not allow a client to join another user's channel", %{user: user} do
      other_user = insert(:user)
      assert {:error, "Unauthorized"} == socket("", %{user_id: user.id}) |> subscribe_and_join(SpadeChannel, "spade:#{other_user.id}")
    end
  end

  describe "get_user" do
    @tag :full_spec
    test "will return a fully preloaded user json", %{user: user, socket: socket} do
      push socket, "get_user", %{}
      assert_broadcast "user_data", payload

      assert payload.id == user.id
      assert payload == Phoenix.View.render(FlatfootWeb.Spade.UserView, "user.json", %{user: user})

      leave socket
    end
  end

  describe "get_ward" do
    @tag :full_spec
    test "will return a fully preloaded ward json", %{user: user, socket: socket} do
      ward = user.wards |> List.first
      push socket, "get_ward", %{"ward_id" => ward.id}

      assert_broadcast message, payload
      assert message == "ward_#{ward.id}_data"
      assert payload.id == ward.id
      assert payload == Phoenix.View.render(FlatfootWeb.WardView, "ward_preload.json", %{ward: ward})

      leave socket
    end

    @tag :socket_only
    test "will raise error if ward does not exist", %{socket: socket} do
      ref = push socket, "get_ward", %{"ward_id" => 0}
      assert_reply ref, :error

      leave socket
    end
  end

  describe "get_ward_account_results" do
    @tag :full_spec
    test "will return all results for an account by default", %{ward_data: ward_data, socket: socket} do
      ward_account_id = ward_data.ward_accounts |> List.first |> Map.get(:id)
      ward_results = get_ward_results_for_account(ward_data.ward_results, ward_account_id)

      push socket, "get_ward_account_results", %{"ward_account_id" => ward_account_id}
      assert_broadcast message, payload
      assert message == "ward_account_#{ward_account_id}_results"
      assert payload.ward_results |> length == ward_results |> length
    end

    @tag :socket_only
    test "will return an empty list for a non-existent ward_account", %{socket: socket} do
      push socket, "get_ward_account_results", %{"ward_account_id" => 0}
      assert_broadcast "ward_account_0_results", %{ward_results: []}
    end

    @tag :full_spec
    test "will return only the results for a given ward_account after a specified as_of date", %{ward_data: ward_data, socket: socket} do
      ward_account_id = ward_data.ward_accounts |> List.first |> Map.get(:id)
      ward_results = get_ward_results_for_account(ward_data.ward_results, ward_account_id)

      push socket, "get_ward_account_results", %{"ward_account_id" => ward_account_id, "as_of" => "2017-01-01"}
      assert_broadcast message, payload
      assert message == "ward_account_#{ward_account_id}_results"
      assert payload == Phoenix.View.render(FlatfootWeb.Spade.WardResultView, "ward_result_list.json", %{ward_results: ward_results})

      push socket, "get_ward_account_results", %{"ward_account_id" => ward_account_id, "as_of" => "2224-01-01"}
      assert_broadcast message, payload
      assert message == "ward_account_#{ward_account_id}_results"
      assert payload == %{ward_results: []}
    end
  end

  describe "get_ward_results_for_user" do
    @tag :full_spec
    test "will return all results for a user", %{socket: socket, ward_data: ward_data, token: token} do
      expected_results = Phoenix.View.render(FlatfootWeb.Spade.WardResultView, "ward_result_list.json", %{ward_results: ward_data.ward_results})

      push socket, "get_ward_results_for_user", %{"token" => token}
      assert_broadcast message, payload
      assert message == "user_ward_results"
      assert payload.ward_results |> length == expected_results.ward_results |> length
      assert payload.ward_results |> Enum.member?(expected_results.ward_results |> List.first)
    end

    @tag :full_spec
    test "will return only the results for a user after a specified as_of date", %{socket: socket, ward_data: ward_data, token: token} do
      expected_results = Phoenix.View.render(FlatfootWeb.Spade.WardResultView, "ward_result_list.json", %{ward_results: ward_data.ward_results})

      push socket, "get_ward_results_for_user", %{"token" => token, "as_of" => "1900-01-01"}
      assert_broadcast message, payload
      assert message == "user_ward_results"
      assert payload.ward_results |> length == expected_results.ward_results |> length
      assert payload.ward_results |> Enum.member?(expected_results.ward_results |> List.first)

      push socket, "get_ward_results_for_user", %{"token" => token, "as_of" => "2200-01-01"}
      assert_broadcast message, payload
      assert message == "user_ward_results"
      assert payload == %{ward_results: []}
    end
  end

  describe "fetch_new_ward_results" do
    @tag :full_spec
    test "will return new results", %{socket: socket, ward_data: ward_data} do
      ward_id = ward_data.wards |> List.first |> Map.get(:id)

      use_cassette "twitter.fetch" do
        push socket, "fetch_new_ward_results", %{"ward_id" => ward_id}
      end

      assert_broadcast message, payload, 1000
      :timer.sleep(50)
      assert message == "new_ward_results"
      payload_result = payload.ward_results |> List.last
      stored_result = Spade.get_ward_result(payload_result.id)
      assert payload_result.id == stored_result.id
      assert payload_result.backend_id == stored_result.backend_id
      assert payload_result.rating == stored_result.rating
      assert payload_result.from == stored_result.from
      assert payload_result.from_id == stored_result.from_id
      assert payload_result.msg_id == stored_result.msg_id
      assert payload_result.msg_text == stored_result.msg_text
      assert payload_result.ward_account_id == stored_result.ward_account_id
    end

    @tag :socket_only
    test "will not return any results with bad ward_id", %{socket: socket} do
      push socket, "fetch_new_ward_results", %{"ward_id" => 0}
      refute_broadcast "new_ward_results", _payload, 200
    end
  end

  describe "fetch_backends" do
    @tag :socket_only
    test "will return all backends", %{socket: socket} do
      backend = insert(:backend)

      push socket, "fetch_backends", %{}
      assert_broadcast "backends_list", payload
      assert backend.id == payload.backends |> List.first |> Map.get(:id)
      assert backend.name == payload.backends |> List.first |> Map.get(:name)
      assert backend.url == payload.backends |> List.first |> Map.get(:url)
      assert backend.module == payload.backends |> List.first |> Map.get(:module)
    end

    @tag :socket_only
    test "will return an empty list if no backends exist", %{socket: socket} do
      push socket, "fetch_backends", %{}
      assert_broadcast "backends_list", %{backends: []}
    end
  end

  describe "create_ward" do
    @tag :full_spec
    test "with valid params, will add a new ward and broadcast the new ward to the channel", %{socket: socket, user: user} do
      name = "Test Name"
      relationship = "dad"
      active = false
      ward_params = %{"name" => name, "relationship" => relationship, "active" => active}

      push socket, "create_ward", %{"ward_params" => ward_params}
      assert_broadcast(message, payload)
      assert message == "new_ward"
      assert payload.user_id == user.id
      assert payload.name == name
      assert payload.relationship == relationship
      assert payload.active == false

      assert Spade.get_ward!(payload.id)
    end

    @tag :socket_only
    test "with invalid params, client will receive invalid attributes error", %{socket: socket} do
      push socket, "create_ward", %{"ward_params" => %{}}
      assert_broadcast "Error: invalid attributes passed for create_ward", %{}
    end

    @tag :socket_only
    test "user_id parameter is ignored", %{socket: socket} do
      user = insert(:user)
      ward_params = %{user_id: user.id, name: "test name", relationship: "test relationship"}

      push socket, "create_ward", %{"ward_params" => ward_params}
      assert_broadcast "new_ward", payload
      refute payload.user_id == user.id
      assert payload.user_id == socket.assigns.user_id
    end
  end

  describe "delete_ward" do
    @tag :full_spec
    test "with valid id, deletes the ward and returns the ward as an object", %{socket: socket, user: user} do
      ward = insert(:ward, user: user)

      push socket, "delete_ward", %{"id" => ward.id}
      assert_broadcast "deleted_ward", payload
      assert payload.id == ward.id
    end

    @tag :socket_only
    test "with invalid id, client will receive an invalid id error", %{socket: socket} do
      push socket, "delete_ward", %{"id" => 0}
      assert_broadcast "Error: invalid ward id for delete_ward", %{"id" => 0}
    end

    @tag :socket_only
    test "cannot delete another user's ward", %{socket: socket} do
      ward = insert(:ward)

      push socket, "delete_ward", %{"id" => ward.id}
      assert_broadcast "Error: unauthorized to delete ward", %{}
    end
  end

  describe "update_ward" do
    @tag :full_spec
    test "with valid id and params, will update and return the record", %{socket: socket, ward_data: ward_data} do
      ward = ward_data.wards |> List.first
      new_name = "new name"
      new_relationship = "sister"
      updated_params = %{name: new_name, relationship: new_relationship}

      push socket, "update_ward", %{"id" => ward.id, "updated_params" => updated_params}
      assert_broadcast "updated_ward", payload
      assert payload.id == ward.id
      refute payload.name == ward.name
      assert payload.name == new_name
      refute payload.relationship == ward.relationship
      assert payload.relationship == new_relationship
    end

    @tag :socket_only
    test "with invalid id, client will receive invalid id error", %{socket: socket} do
      updated_params = %{name: "new name"}

      push socket, "update_ward", %{"id" => 0, "updated_params" => updated_params}
      assert_broadcast "Error: invalid ward_id", %{"id" => 0}
    end

    @tag :socket_only
    test "cannot edit another user's ward", %{socket: socket} do
      ward = insert(:ward)
      updated_params = %{name: "new name"}

      push socket, "update_ward", %{"id" => ward.id, "updated_params" => updated_params}
      assert_broadcast "Error: unauthorized to edit ward", %{}
    end
  end

  describe "create_ward_account" do
    @tag :full_spec
    test "with valid params, will create a ward_account", %{socket: socket, ward_data: ward_data} do
      ward = ward_data.wards |> List.first
      handle = "@handle"
      ward_id = ward.id
      backend_id = ward_data.backend.id
      params = %{handle: handle, backend_id: backend_id, ward_id: ward_id}

      push socket, "create_ward_account", %{ward_account_params: params}
      assert_broadcast "new_ward_account", payload
      assert payload.handle == handle
      assert payload.ward_id == ward_id
    end

    @tag :socket_only
    test "with invalid params, user will receive error message", %{socket: socket} do
      push socket, "create_ward_account", %{ward_account_params: %{}}
      assert_broadcast "Error: invalid parameters", %{"ward_account_params" => %{}}
    end

    @tag :socket_only
    test "with invalid ward_id, returns error", %{socket: socket} do
      backend = insert(:backend)
      push socket, "create_ward_account", %{ward_account_params: %{handle: "@j", ward_id: 0, backend_id: backend.id}}
      assert_broadcast "Error: invalid ward or backend association", payload
      assert payload.backend_id == backend.id
      assert payload.ward_id == 0
    end

    @tag :socket_only
    test "with invalid backend_id, returns error", %{socket: socket} do
      ward = insert(:ward)
      push socket, "create_ward_account", %{ward_account_params: %{handle: "@j", ward_id: ward.id, backend_id: 0}}
      assert_broadcast "Error: invalid ward or backend association", payload
      assert payload.ward_id == ward.id
      assert payload.backend_id == 0
    end

    @tag :socket_only
    test "cannot add a ward_account for another user's ward", %{socket: socket} do
      ward = insert(:ward)
      backend = insert(:backend)

      push socket, "create_ward_account", %{ward_account_params: %{handle: "@jon", ward_id: ward.id, backend_id: backend.id}}
      assert_broadcast "Error: unauthorized to add a ward_account for another user's ward", %{}
    end
  end

  describe "delete_ward_account" do
    @tag :full_spec
    test "with valid id, will delete a ward_account", %{socket: socket, ward_data: ward_data} do
      ward_account = ward_data.ward_accounts |> List.first

      push socket, "delete_ward_account", %{id: ward_account.id}
      assert_broadcast "deleted_ward_account", payload
      assert payload.id == ward_account.id
      assert payload.handle == ward_account.handle
    end

    @tag :socket_only
    test "with invalid id, will return error", %{socket: socket} do
      push socket, "delete_ward_account", %{id: 0}
      assert_broadcast "Error: invalid id", %{"id" => 0}
    end

    @tag :socket_only
    test "cannot delete another user's ward_account", %{socket: socket} do
      ward_account = insert(:ward_account)

      push socket, "delete_ward_account", %{"id" => ward_account.id}
      assert_broadcast "Error: Unauthorized to delete another user's ward_account", %{}
    end
  end

  describe "update_ward_account" do
    @tag :full_spec
    test "with valid id and params, will update a ward_account", %{socket: socket, ward_data: ward_data} do
      ward_account = ward_data.ward_accounts |> List.first
      new_handle = "@new_handle"
      backend = insert(:backend)
      new_params = %{handle: new_handle, backend_id: backend.id}

      push socket, "update_ward_account", %{"id" => ward_account.id, "updated_params" => new_params}
      assert_broadcast "updated_ward_account", payload
      assert payload.handle == new_handle
      assert payload.backend_module == backend.module
    end

    @tag :socket_only
    test "with invalid id, returns an error message", %{socket: socket} do
      push socket, "update_ward_account", %{"id" => 0, "updated_params" => %{}}
      assert_broadcast "Error: invalid id", %{"id" => 0}
    end

    @tag :socket_only
    test "cannot update a ward_account for another user", %{socket: socket} do
      ward_account = insert(:ward_account)
      push socket, "update_ward_account", %{"id" => ward_account.id, "updated_params" => %{"handle" => "@new_name"}}
      assert_broadcast "Error: unauthorized to edit ward_account", %{}
    end
  end

  describe "clear_ward_result" do
    @tag :full_spec
    test "with valid ward_result id, will delete the ward_result and return the deleted result", %{socket: socket, ward_data: ward_data} do
      ward_result = ward_data.ward_results |> List.first
      push socket, "clear_ward_result", %{"id" => ward_result.id}
      assert_broadcast "cleared_ward_result", payload
      assert payload.msg_id == ward_result.msg_id
    end

    @tag :socket_only
    test "with invalid ward_result id, returns error message", %{socket: socket} do
      push socket, "clear_ward_result", %{"id" => 0}
      assert_broadcast "Error: invalid ward_result id", %{"id" => 0}
    end

    @tag :socket_only
    test "cannot clear another user's ward_result", %{socket: socket} do
      ward_result = insert(:ward_result)
      push socket, "clear_ward_result", %{"id" => ward_result.id}
      assert_broadcast "Error: unauthorized to clear ward_result", %{}
    end
  end

  describe "clear_ward_results w/ ward_account_id" do
    @tag :full_spec
    test "with valid ward_account id, will delete all associated ward results", %{socket: socket, ward_data: ward_data} do
      ward_account = ward_data.ward_accounts |> List.first
      ward_results = Spade.get_ward_account_preload!(ward_account.id) |> Map.get(:ward_results)
      assert ward_results |> length == 2

      push socket, "clear_ward_results", %{"ward_account_id" => ward_account.id}
      assert_broadcast "cleared_ward_results", payload

      assert payload.ward_results |> length == ward_results |> length
      assert Phoenix.View.render(FlatfootWeb.Spade.WardResultView, "ward_result_list.json", %{ward_results: ward_results}) |> Map.get(:ward_results) |> List.first == payload.ward_results |> List.last
      assert Spade.get_ward_account_preload!(ward_account.id) |> Map.get(:ward_results) |> length == 0
    end

    @tag :socket_only
    test "with invalid ward_account id, will broadcast error message", %{socket: socket} do
      push socket, "clear_ward_results", %{"ward_account_id" => 0}
      assert_broadcast "Error: invalid ward_account id", %{"ward_account_id" => 0}
    end

    @tag :socket_only
    test "cannot clear another user's ward_results", %{socket: socket} do
      ward_account = insert(:ward_account)
      push socket, "clear_ward_results", %{"ward_account_id" => ward_account.id}
      assert_broadcast "Error: unauthorized to access this ward_account", %{}
    end
  end

  describe "clear_ward_results w/ ward_id" do
    @tag :full_spec
    test "with valid ward id, will delete all associated", %{socket: socket, ward_data: ward_data} do
      ward = ward_data.wards |> List.first
      ward_results = ward.id |> Spade.get_ward_preload_with_results |> Map.get(:ward_accounts) |> Enum.map(&(&1.ward_results)) |> List.flatten
      assert ward_results |> length == 4

      push socket, "clear_ward_results", %{"ward_id" => ward.id}
      assert_broadcast "cleared_ward_results", payload

      assert payload.ward_results |> length == ward_results |> length
      assert Phoenix.View.render(FlatfootWeb.Spade.WardResultView, "ward_result_list.json", %{ward_results: ward_results}) |> Map.get(:ward_results) |> List.first == payload.ward_results |> List.last
      assert ward.id |> Spade.get_ward_preload_with_results |> Map.get(:ward_accounts) |> Enum.map(&(&1.ward_results)) |> List.flatten |> length == 0
    end

    @tag :socket_only
    test "with invalid ward id, will broadcast an error", %{socket: socket} do
      push socket, "clear_ward_results", %{"ward_id" => 0}
      assert_broadcast "Error: invalid ward id", %{"ward_id" => 0}
    end

    @tag :socket_only
    test "cannot clear another user's ward_results", %{socket: socket} do
      ward = insert(:ward)
      push socket, "clear_ward_results", %{"ward_id" => ward.id}
      assert_broadcast "Error: unauthorized to access this ward", %{}
    end
  end

  #####################
  # Private Functions #
  #####################

  defp generate_and_return_watchlist_data(user) do
    watchlists = insert_list(2, :watchlist, user: user)
    backend = insert(:backend, module: "Elixir.Flatfoot.Archer.Backend.Twitter")
    suspects =
      watchlists
      |> Enum.map(fn (watchlist) ->
        insert_list(2, :suspect, watchlist: watchlist)
      end)
    suspect_accounts =
      suspects
      |> List.flatten
      |> Enum.map(fn (suspect) ->
        insert_list(2, :suspect_account, suspect: suspect, backend: backend)
      end)

    {:ok, %{watchlists: watchlists, backend: backend, suspects: suspects |> List.flatten, suspect_accounts: suspect_accounts |> List.flatten}}
  end

  defp generate_and_return_ward_data(user) do
    wards = insert_list(2, :ward, user: user)
    backend = insert(:backend, module: "Elixir.Flatfoot.Archer.Backend.Twitter")
    ward_accounts =
      wards
      |> Enum.map(fn (ward) ->
        insert_list(2, :ward_account, ward: ward, backend: backend)
      end)
    ward_results =
      ward_accounts
      |> List.flatten
      |> Enum.map(fn (ward_account) ->
        insert_list(2, :ward_result, backend: backend, ward_account: ward_account)
      end)

    {:ok, %{wards: wards, backend: backend, ward_accounts: ward_accounts |> List.flatten, ward_results: ward_results |> List.flatten}}
  end

  defp get_ward_results_for_account(ward_results, ward_account_id) do
    ward_results
    |> List.foldl([], fn (ward_result, acc) ->
      if ward_result.ward_account_id == ward_account_id, do: [ward_result | acc], else: acc
    end)
  end
end
