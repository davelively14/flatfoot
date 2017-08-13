defmodule FlatfootWeb.SpadeViewTest do
  use FlatfootWeb.ConnCase, async: true
  # import Phoenix.View
  alias Flatfoot.Spade
  alias FlatfootWeb.WatchlistView

  setup do
    watchlist = insert(:watchlist)
    suspect = insert(:suspect, watchlist: watchlist)
    backend = insert(:backend)
    suspect_account = insert(:suspect_account, suspect: suspect, backend: backend)

    preloaded_watchlist = Spade.get_watchlist_preload!(watchlist.id)

    {:ok, %{watchlist: preloaded_watchlist, suspect: suspect, backend: backend, suspect_account: suspect_account}}
  end

  describe "watchlist_view" do
    test "with valid watchlist, watchlist.json returns JSON of the watchlist", %{watchlist: watchlist, suspect: suspect, backend: backend, suspect_account: suspect_account} do
      result = WatchlistView.render("watchlist.json", %{watchlist: watchlist})
      assert result.id == watchlist.id

      [result_suspect] = result.suspects
      assert result_suspect.id == suspect.id

      [result_account] = result_suspect.suspect_accounts
      assert result_account.id == suspect_account.id
      assert result_account.network == backend.name
    end

    test "with a not-preloaded watchlist, raises protocol error" do
      watchlist = insert(:watchlist)
      assert_raise Protocol.UndefinedError, fn -> WatchlistView.render("watchlist.json", %{watchlist: watchlist}) end
    end

    test "when not passed watchlist, raises key error" do
      assert_raise KeyError, fn -> WatchlistView.render("watchlist.json", %{watchlist: %{}}) end
    end
  end
end
