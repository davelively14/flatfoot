defmodule Flatfoot.SpadeInspector.ServerTest do
  use Flatfoot.DataCase
  alias Flatfoot.SpadeInspector.{SpadeInspectorSupervisor, Server}

  describe "get_state/0" do
    test "returns state" do
      SpadeInspectorSupervisor.start_link()
      assert %Server.State{} = _ = Server.get_state()
    end
  end
end
