defmodule Flatfoot.SpadeInspector.ServerTest do
  use Flatfoot.DataCase
  alias Flatfoot.SpadeInspector.{Server}

  describe "get_state/0" do
    test "returns state" do
      assert %Server.InspectorState{} = _ = Server.get_state()
    end
  end
end
