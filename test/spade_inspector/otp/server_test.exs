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
      assert %Server.InspectorState{} = state = Server.get_state()
      assert state.sup |> is_pid
      assert state.negative_words |> Map.get("haskdfj") == nil
      assert state.negative_words |> Map.get("dick") == 5
    end
  end

  describe "fetch_update/1" do
    test "with valid ward_id, casts and awaits reply" do
      user = insert(:user)
      ward = insert(:ward, user: user)
      backend = insert(:backend, module: "Elixir.Flatfoot.Archer.Backend.Twitter")
      ward_account = insert(:ward_account, ward: ward, backend: backend, handle: "@sarahinatlanta")

      assert Server.fetch_update(ward.id) == :ok

      # TODO fix this async issue
      # If I don't put this in, the server will quit before the Archer system
      # can return the results and it will raise an error. The tests sill pass,
      # but the error is ugly.
      :timer.sleep(800)
      result = Flatfoot.Spade.WardResult |> Flatfoot.Repo.all |> List.last
      assert result.backend_id == backend.id
      assert result.ward_account_id == ward_account.id
    end
  end

  describe "parse_result/1" do
    test "parses and stores result" do
      ward_result = insert(:ward_result) |> Map.from_struct |> Map.put(:id, nil)

      {:ok, %Flatfoot.SpadeInspector.WardResult{} = result} = Server.parse_result(ward_result)
      assert result == Flatfoot.SpadeInspector.WardResult |> Flatfoot.Repo.all |> List.last
      assert result.backend_id == ward_result.backend_id
      assert result.ward_account_id == ward_result.ward_account_id
    end
  end
end
