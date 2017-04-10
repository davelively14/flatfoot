defmodule Flatfoot.SpadeTest do
  use Flatfoot.DataCase

  alias Flatfoot.{Spade}

  ###########
  # Backend #
  ###########

  describe "list_backends/0" do
    test "will return all backends" do
      backends = insert_list(3, :archer_backend)
      results = Spade.list_backends()

      assert backends |> length == results |> length
    end

    test "will return the correct backends" do
      backend = insert(:archer_backend)

      [result] = Spade.list_backends()
      assert result.id == backend.id
      assert result.name == backend.name
      assert result.url == backend.url

      assert_raise KeyError, fn -> result.name_snake end
      assert_raise KeyError, fn -> result.module end
    end

    test "will return empty list if no backends stored" do
      assert [] == Spade.list_backends()
    end
  end

  describe "get_backend!/1" do
    test "with valid id returns a backend" do
      backend = insert(:archer_backend)
      result = Spade.get_backend!(backend.id)

      assert result.id == backend.id
      assert result.name == backend.name
      assert result.url == backend.url

      assert_raise KeyError, fn -> result.name_snake end
      assert_raise KeyError, fn -> result.module end
    end

    test "with invalid id raises error" do
      assert_raise Ecto.NoResultsError, fn -> Spade.get_backend!(0) end
    end
  end
end
