defmodule Flatfoot.Archer.ServerTest do
  use Flatfoot.DataCase
  alias Flatfoot.Archer.{ArcherSupervisor, Server, Backend.Twitter}

  describe "get_state/0" do
    test "starts up and returns state" do
      ArcherSupervisor.start_link()
      assert %Server.State{} = _ = Server.get_state()
    end
  end

  describe "fetch_data/1" do
    test "with correct params, sends hello world back to process that calls it" do
      ArcherSupervisor.start_link()
      config = [
        %{mfa: {Twitter, :fetch, [self(), %{q: "hello world"}]}}
      ]
      Server.fetch_data(config)
      assert_receive(%{"search_metadata" => _}, 2_000)
    end
  end
end
