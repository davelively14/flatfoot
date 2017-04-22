defmodule Flatfoot.SpadeInspector.QueryTest do
  use Flatfoot.DataCase
  alias Flatfoot.SpadeInspector.Query

  describe "build/1" do
    test "with valid string, returns propery query format" do
      ward_account = insert(:ward_account, handle: "handle")
      assert %{q: "to:handle"} == Query.build(ward_account)
    end
  end
end
