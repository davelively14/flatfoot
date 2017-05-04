defmodule Flatfoot.Web.SpadeChannelTest do
  use Flatfoot.Web.ChannelCase
  alias Flatfoot.{Web.SpadeChannel, Spade}

  setup config do
    user = insert(:user)

    cond do
      config[:full_spec] ->
        generate_and_preload_watchlists(user)
        generate_and_preload_wards(user)
        user = Spade.get_user_preload(user.id)
        {:ok, resp, socket} = socket("", %{}) |> subscribe_and_join(SpadeChannel, "spade:#{user.id}")
        {:ok, %{user: user, resp: resp, socket: socket}}

      config[:user_preloaded] ->
        generate_and_preload_watchlists(user)
        generate_and_preload_wards(user)
        user = Spade.get_user_preload(user.id)
        {:ok, %{user: user}}

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

    @tag :full_spec
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

    @tag :full_spec
    test "will raise error if ward does not exist", %{socket: socket} do
      ref = push socket, "get_ward", %{"ward_id" => 0}
      assert_reply ref, :error

      leave socket
    end
  end

  describe "get_ward_account_results" do
    @tag :full_spec
    test "will return multiple results", %{resp: resp, socket: socket} do

    end
  end

  #####################
  # Private Functions #
  #####################

  defp generate_and_preload_watchlists(user) do
    watchlists = insert_list(2, :watchlist, user: user)
    backend = insert(:backend)
    suspects =
      watchlists
      |> Enum.map(fn (watchlist) ->
        insert_list(2, :suspect, watchlist: watchlist)
      end)
    _suspect_accounts =
      suspects
      |> List.flatten
      |> Enum.map(fn (suspect) ->
        insert_list(2, :suspect_account, suspect: suspect, backend: backend)
      end)

    Spade.list_watchlists_preload(user.id)
  end

  defp generate_and_preload_wards(user) do
    wards = insert_list(2, :ward, user: user)
    backend = insert(:backend)
    ward_accounts =
      wards
      |> Enum.map(fn (ward) ->
        insert_list(2, :ward_account, ward: ward, backend: backend)
      end)
    _ward_results =
      ward_accounts
      |> List.flatten
      |> Enum.map(fn (ward_account) ->
        insert_list(2, :ward_result, backend: backend, ward_account: ward_account)
      end)

    Spade.list_wards_preload(user.id)
  end
end
