defmodule Flatfoot.Archer.Backend.TwitterTest do
  use Flatfoot.DataCase
  alias Flatfoot.Archer.{Backend.Twitter}

  describe "fetch/1" do
    test "with valid parameters, will send us results" do
      query = %{q: "to:sarahinatlanta", since_id: "852856862471069696"}
      Twitter.fetch(self(), query)
      assert_receive(%{"search_metadata" => _}, 2_000)
    end
  end
end
