defmodule Flatfoot.Archer.Backend.TwitterTest do
  use Flatfoot.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Flatfoot.Archer.{Backend.Twitter}

  setup_all do
    ExVCR.Config.cassette_library_dir("test/support/vcr_cassettes")
    :ok
  end

  describe "fetch/1" do
    test "with valid parameters, will send us results" do
      use_cassette "twitter.fetch" do
        query = %{q: "to:sarahinatlanta", since_id: "852856862471069696"}
        Twitter.fetch(self(), query)
        assert_receive(%{"search_metadata" => _}, 2_000)
      end
    end
  end
end
