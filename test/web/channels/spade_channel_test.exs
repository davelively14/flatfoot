defmodule Flatfoot.Web.SpadeChannelTest do
  use Flatfoot.Web.ChannelCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Flatfoot.{Web.SpadeChannel, Spade}

  setup config do
    ExVCR.Config.cassette_library_dir("test/support/vcr_cassettes")
    user = insert(:user)

    cond do
      config[:full_spec] ->
        {:ok, watchlist_data} = generate_and_return_watchlist_data(user)
        {:ok, ward_data} = generate_and_return_ward_data(user)
        user = Spade.get_user_preload(user.id)
        {:ok, resp, socket} = socket("", %{}) |> subscribe_and_join(SpadeChannel, "spade:#{user.id}")
        {:ok, %{user: user, resp: resp, socket: socket, ward_data: ward_data, watchlist_data: watchlist_data}}

      config[:user_preloaded] ->
        generate_and_return_watchlist_data(user)
        generate_and_return_ward_data(user)
        user = Spade.get_user_preload(user.id)
        {:ok, %{user: user}}

      config[:socket_only] ->
        {:ok, _resp, socket} = socket("", %{}) |> subscribe_and_join(SpadeChannel, "spade:#{user.id}")
        {:ok, %{socket: socket}}

      config[:empty_user_only] ->
        {:ok, %{user: user}}

      true ->
        :ok
    end
  end

  @tag :user_preloaded
  describe "join" do
    test "will return response and socket", %{user: user} do
      {:ok, resp, socket} = socket("", %{}) |> subscribe_and_join(SpadeChannel, "spade:#{user.id}")

      assert resp == Phoenix.View.render(Flatfoot.Web.Spade.UserView, "user.json", %{user: user})
      assert socket.channel == Flatfoot.Web.SpadeChannel
      assert socket.assigns.user_id == user.id
      leave socket
    end

    test "will return error if no valid user given" do
      assert {:error, "User does not exist"} == subscribe_and_join(socket("", %{}), SpadeChannel, "spade:#{0}")
    end
  end

  describe "get_user" do
    @tag :full_spec
    test "will return a fully preloaded user json", %{user: user, socket: socket} do
      push socket, "get_user", %{"user_id" => user.id}
      assert_broadcast "user_data", payload

      assert payload.id == user.id
      assert payload == Phoenix.View.render(Flatfoot.Web.Spade.UserView, "user.json", %{user: user})

      leave socket
    end

    @tag :socket_only
    test "will return error if user does not exist", %{socket: socket} do
      ref = push socket, "get_user", %{"user_id" => 0}
      assert_reply ref, :error

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
      assert payload == Phoenix.View.render(Flatfoot.Web.WardView, "ward.json", %{ward: ward})

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
      assert payload == Phoenix.View.render(Flatfoot.Web.Spade.WardResultView, "ward_result_list.json", %{ward_results: ward_results})
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
      assert payload == Phoenix.View.render(Flatfoot.Web.Spade.WardResultView, "ward_result_list.json", %{ward_results: ward_results})

      push socket, "get_ward_account_results", %{"ward_account_id" => ward_account_id, "as_of" => "2224-01-01"}
      assert_broadcast message, payload
      assert message == "ward_account_#{ward_account_id}_results"
      assert payload == %{ward_results: []}
    end
  end

  describe "fetch_new_ward_results" do
    @tag :full_spec
    @tag :current_test
    test "will return new results", %{socket: socket, ward_data: ward_data} do
      ward_id = ward_data.wards |> List.first |> Map.get(:id)

      push socket, "fetch_new_ward_results", %{"ward_id" => ward_id}
      assert_broadcast message, payload, 1000
      assert message == "new_ward_results"
      assert payload |> is_map
    end
  end

  #####################
  # Private Functions #
  #####################

  defp generate_and_return_watchlist_data(user) do
    watchlists = insert_list(2, :watchlist, user: user)
    backend = insert(:backend, module: "Flatfoot.Archer.Backend.Twitter")
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
