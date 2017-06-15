defmodule Flatfoot.ArcherTest do
  use Flatfoot.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Flatfoot.{Archer}

  setup_all do
    ExVCR.Config.cassette_library_dir("test/support/vcr_cassettes")
    :ok
  end

  ###########
  # Backend #
  ###########

  describe "list_backends/0" do
    test "returns all backends" do
      backends = insert_list(3, :backend)
      results = Archer.list_backends()

      assert results |> length == backends |> length
    end

    test "returns the correct backends" do
      backend = insert(:backend)
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
      assert backend.module == "Elixir.Flatfoot.Archer.Backend.SomeName"
    end

    test "with invalid attiributes will return errors" do
      {:error, changeset} = Archer.create_backend(%{})

      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:url] == {"can't be blank", [validation: :required]}
    end
  end

  describe "get_backend!/1" do
    test "with valid id returns a backend" do
      backend = insert(:backend)
      result = Archer.get_backend!(backend.id)
      assert backend == result
    end

    test "with invalid id raises error" do
      assert_raise Ecto.NoResultsError, fn -> Archer.get_backend!(0) end
    end
  end

  describe "fetch_data/1" do
    test "with valid configs, returns :ok and new data" do
      user = insert(:user)
      ward = insert(:ward, user: user)
      backend = insert(:backend, module: "Elixir.Flatfoot.Archer.Backend.Twitter")
      ward_account = insert(:ward_account, backend: backend, ward: ward)

      configs = [%{mfa: {
          backend.module |> String.to_atom,
          :fetch,
          [self(), %{user_id: user.id, ward_account_id: ward_account.id, backend_id: backend.id}, ward_account.handle, ""]
        }
      }]

      use_cassette "twitter.fetch" do
        Archer.fetch_data(configs)
      end

      assert_receive {:result, ids, result}
      assert ids == %{backend_id: backend.id, user_id: user.id, ward_account_id: ward_account.id}
      assert result |> is_list
    end
  end
end
