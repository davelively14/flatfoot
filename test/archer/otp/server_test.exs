defmodule Flatfoot.Archer.ServerTest do
  use Flatfoot.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Flatfoot.Archer.{ArcherSupervisor, Server, Backend.Twitter}

  setup_all do
    ExVCR.Config.cassette_library_dir("test/support/vcr_cassettes")
    :ok
  end

  describe "get_state/0" do
    test "starts up and returns state" do
      ArcherSupervisor.start_link()
      assert %Server.ArcherState{} = _ = Server.get_state()
    end
  end

  describe "fetch_data/1" do
    test "with correct params, sends hello world back to process that calls it" do
      use_cassette "twitter.fetch" do
        ArcherSupervisor.start_link()
        config = [
          %{mfa: {Twitter, :fetch, [self(), %{q: "hello world"}]}}
        ]
        Server.fetch_data(config)
        assert_receive(%{"search_metadata" => _}, 2_000)
      end
    end
  end
end
