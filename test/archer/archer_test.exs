defmodule Flatfoot.ArcherTest do
  use Flatfoot.DataCase

  alias Flatfoot.{Archer}

  ###########
  # Backend #
  ###########

  describe "list_backends/0" do
    test "returns all backends" do
      backends = insert_list(3, :archer_backend)
      results = Archer.list_backends()

      assert results |> length == backends |> length
    end

    test "returns the correct backends" do
      backend = insert(:archer_backend)
      results = Archer.list_backends()

      assert [backend] == results
    end

    test "returns empty list if no backends exist" do
      results = Archer.list_backends()

      assert [] == results
    end
  end
end
