defmodule Flatfoot.Archer.ServerTest do
  use Flatfoot.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Flatfoot.Archer.{Server, Backend.Twitter}

  setup_all do
    ExVCR.Config.cassette_library_dir("test/support/vcr_cassettes")
    :ok
  end

  describe "get_state/0" do
    test "starts up and returns state" do
      assert %Server.ArcherState{} = _ = Server.get_state()
    end
  end

  describe "fetch_data/3" do
    test "with correct params, sends hello world back to process that calls it" do
      use_cassette "twitter.fetch" do
        config = [
          %{mfa: {Twitter, :fetch, [self(), %{test: "test"}, %{q: "hello world"}]}}
        ]
        Server.fetch_data(config)
        assert_receive({:result, %{test: "test"}, %{"search_metadata" => _}}, 2_000)
      end
    end
  end
end
