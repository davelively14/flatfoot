defmodule Flatfoot.Archer.OtpTest do
  use Flatfoot.DataCase
  alias Flatfoot.Archer.{ArcherSupervisor, Server}

  describe "ArcherServer" do
    test "starts up and returns state" do
      ArcherSupervisor.start_link()
      assert %Flatfoot.Archer.Server.State{} = _ = Server.get_state()
    end
  end
end
