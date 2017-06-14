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
    end
  end

  describe "fetch_update/1" do
    test "with valid ward_id, casts and awaits reply" do
      user = insert(:user)
      ward = insert(:ward, user: user)
      backend = insert(:backend, module: "Elixir.Flatfoot.Archer.Backend.Twitter")
      ward_account = insert(:ward_account, ward: ward, backend: backend, handle: "@sarahinatlanta")

      use_cassette "twitter.fetch" do
        assert Server.fetch_update(ward.id) == :ok


        # TODO: fix this async issue
        # If I don't put this in, the server will quit before the Archer system
        # can store the results and it will raise an error. The tests sill pass,
        # but the sleeper is ugly. Need to get PID for server and then trace
        # via :erlang.trace.
        :timer.sleep(100)
        # :erlang.trace(pid, true, [:receive])
        # assert_receive {:trace, ^pid, :receive, {:result, _, _}}
        result = Flatfoot.Spade.WardResult |> Flatfoot.Repo.all |> List.last
        assert result.backend_id == backend.id
        assert result.ward_account_id == ward_account.id
        assert result.rating == 38
      end
    end

    test "with invalid ward_id, will not cast" do
      starting_recent = Flatfoot.Spade.WardResult |> Flatfoot.Repo.all |> List.last
      assert Server.fetch_update(0) == :ok
      :timer.sleep(100)
      ending_recent = Flatfoot.Spade.WardResult |> Flatfoot.Repo.all |> List.last
      assert starting_recent == ending_recent
    end
  end

  describe "rate_message/1" do
    test "rates string correctly" do
      result = Server.get_rating("bastard")
      assert result |> is_integer
      assert result == 25
    end

    test "rates high end words correctly" do
      result = Server.get_rating("bully bullies bastard")
      assert result == 100
    end

    test "rates suicide correctly" do
      result = Server.get_rating("suicide")
      assert result == 100
    end

    test "rates suicidal correctly" do
      result = Server.get_rating("suicidal")
      assert result == 100
    end

    test "freddy e" do
      result = Server.get_rating("If there's a God, he's calling me back home. This barrel never felt so good next to my dome. It's cold & I'd rather die than live alone.")
      assert result >= 50
    end

    test "santa barbara killer" do
      result = Server.get_rating("I hate all of you. If I had it in my power, I would stop at nothing to reduce every single one of you to mountains of skulls and rivers of blood")
      assert result > 70
    end
  end
end
