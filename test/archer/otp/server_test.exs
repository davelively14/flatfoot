defmodule Flatfoot.Archer.ServerTest do
  use Flatfoot.DataCase
  alias Flatfoot.Archer.{ArcherSupervisor, Server, Backends.Twitter}

  describe "get_state/0" do
    test "starts up and returns state" do
      ArcherSupervisor.start_link()
      assert %Server.State{} = _ = Server.get_state()
    end
  end

  describe "fetch_data/1" do
    IO.inspect %{server_test_pid: self()}
    assert ArcherSupervisor.start_link()
    config = [
      %{mfa: {Twitter, :start_link, ["hello world"]}}
    ]
    Server.fetch_data(config)
  end
end
