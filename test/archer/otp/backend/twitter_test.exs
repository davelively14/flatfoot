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
        ids = %{test: "test", ward_account_id: 1, backend_id: 1}
        Twitter.fetch(self(), ids, "@sarahinatlanta", "852856862471069696")
        assert_receive({:result, ids_received, results}, 2_000)
        assert ids_received == ids
        assert results |> is_list
      end
    end

    test "with invalid parameters, raises errors" do
      assert_raise UndefinedFunctionError, fn -> Twitter.fetch(nil, nil) end
      assert_raise FunctionClauseError, fn -> Twitter.fetch(self(), 1, "hello world", "") end
      assert_raise FunctionClauseError, fn -> Twitter.fetch(self(), "abc", %{q: "hello world"}, "") end
      assert_raise FunctionClauseError, fn -> Twitter.fetch(12, 1, %{q: "hello world"}, "") end
    end
  end
end
