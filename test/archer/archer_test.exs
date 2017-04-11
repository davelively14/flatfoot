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

  describe "create_backend/1" do
    test "with valid attributes will create a backend" do
      name = "some name"
      url = Faker.Internet.url

      {:ok, backend} = Archer.create_backend(%{name: name, url: url})
      assert backend.name == name
      assert backend.url == url
      assert backend.name_snake == "some_name"
      assert backend.module == "Flatfoot.Archer.SomeName"
    end

    test "with invalid attiributes will return errors" do
      {:error, changeset} = Archer.create_backend(%{})

      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:url] == {"can't be blank", [validation: :required]}
    end
  end

  describe "get_backend!/1" do
    test "with valid id returns a backend" do
      backend = insert(:archer_backend)
      result = Archer.get_backend!(backend.id)
      assert backend == result
    end

    test "with invalid id raises error" do
      assert_raise Ecto.NoResultsError, fn -> Archer.get_backend!(0) end
    end
  end
end
