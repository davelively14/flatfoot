defmodule Flatfoot.SpadeInspector.ServerTest do
  use Flatfoot.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Flatfoot.SpadeInspector.{Server}

  setup_all do
    ExVCR.Config.cassette_library_dir("test/support/vcr_cassettes")
    :ok
  end

  describe "get_state/0" do
    test "returns state" do
      assert %Server.InspectorState{} = _ = Server.get_state()
    end
  end

  describe "fetch_update/1" do
    test "TBD" do
      
    end
  end
end
