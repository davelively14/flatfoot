defmodule Flatfoot.SpadeInspectorTest do
  use Flatfoot.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Flatfoot.SpadeInspector

  setup_all do
    ExVCR.Config.cassette_library_dir("test/support/vcr_cassettes")
    :ok
  end

  ###############
  # Ward Result #
  ###############

  describe "create_ward_result/1" do
    test "with valid attributes, will create a suspect account" do
      ward_account = insert(:ward_account)
      backend = insert(:backend)
      attrs = %{
        rating: Enum.random(0..100),
        from: Faker.Internet.user_name,
        from_id: Enum.random(1000..9999) |> to_string,
        msg_id: Enum.random(1000..1999) |> to_string,
        msg_text: Faker.Lorem.Shakespeare.hamlet,
        ward_account_id: ward_account.id,
        backend_id: backend.id,
        timestamp: Ecto.DateTime.cast(%{year: 2017, month: Enum.random(1..3), day: Enum.random(1..15), hour: Enum.random(0..23), minute: Enum.random([0, 15, 30, 45]), second: 0}) |> elem(1)
      }

      {:ok, result} = SpadeInspector.create_ward_result(attrs)
      assert result.rating == attrs.rating
      assert result.msg_id == attrs.msg_id
      assert result.msg_text == attrs.msg_text
      assert result.from == attrs.from
      assert result.from_id == attrs.from_id
      assert result.backend_id == attrs.backend_id
      assert result.ward_account_id == attrs.ward_account_id
    end

    test "with valid attributes, will update a ward_acccount with new last_msg" do
      ward_account = insert(:ward_account)
      backend = insert(:backend)
      attrs = %{
        rating: Enum.random(0..100),
        from: Faker.Internet.user_name,
        from_id: Enum.random(1000..9999) |> to_string,
        msg_id: Enum.random(1000..1999) |> to_string,
        msg_text: Faker.Lorem.Shakespeare.hamlet,
        ward_account_id: ward_account.id,
        backend_id: backend.id,
        timestamp: Ecto.DateTime.cast(%{year: 2017, month: Enum.random(1..3), day: Enum.random(1..15), hour: Enum.random(0..23), minute: Enum.random([0, 15, 30, 45]), second: 0}) |> elem(1)
      }

      SpadeInspector.create_ward_result(attrs)
      ward_account = Flatfoot.Spade.get_ward_account(ward_account.id)
      assert ward_account.last_msg == attrs.msg_id
    end

    test "will select the correct last_msg to asssign to ward_account" do
      ward_account = insert(:ward_account)
      backend = insert(:backend)
      attrs1 = %{
        rating: Enum.random(0..100),
        from: Faker.Internet.user_name,
        from_id: Enum.random(1000..9999) |> to_string,
        msg_id: "10001",
        msg_text: Faker.Lorem.Shakespeare.hamlet,
        ward_account_id: ward_account.id,
        backend_id: backend.id,
        timestamp: Ecto.DateTime.cast({{2017, 1, 1}, {0, 0, 0}}) |> elem(1)
      }
      attrs2 = %{
        rating: Enum.random(0..100),
        from: Faker.Internet.user_name,
        from_id: Enum.random(1000..9999) |> to_string,
        msg_id: "100",
        msg_text: Faker.Lorem.Shakespeare.hamlet,
        ward_account_id: ward_account.id,
        backend_id: backend.id,
        timestamp: Ecto.DateTime.cast({{2016, 1, 1}, {0, 0, 0}}) |> elem(1)
      }

      SpadeInspector.create_ward_result(attrs1)
      SpadeInspector.create_ward_result(attrs2)
      ward_account = Flatfoot.Spade.get_ward_account(ward_account.id)
      assert ward_account.last_msg == attrs1.msg_id
    end

    test "with invalid attributes, will return a changeset with errors" do
      {:error, changeset} = SpadeInspector.create_ward_result(%{})

      assert changeset.errors[:rating] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:msg_id] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:msg_text] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:from] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:ward_account_id] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:backend_id] == {"can't be blank", [validation: :required]}

      {:error, changeset} = SpadeInspector.create_ward_result(%{rating: 105})
      assert changeset.errors[:rating] == {"is invalid", [validation: :inclusion]}
    end
  end

  describe "spade_inspector/1" do
    test "returns :ok regardless" do
      ward = insert(:ward)

      use_cassette "twitter.fetch" do
        assert :ok == SpadeInspector.fetch_update(ward.id)
        assert :ok == SpadeInspector.fetch_update(0)
        :timer.sleep(50)
      end
    end
  end

  describe "get_last_ward_result_msg_id/1" do
    test "with valid ward_account id, returns correct result" do
      ward_account = insert(:ward_account)
      ward_result_latest = insert(:ward_result, ward_account: ward_account, timestamp: Ecto.DateTime.cast({{2017, 1, 1}, {0, 0, 0}}) |> elem(1))
      insert(:ward_result, ward_account: ward_account, timestamp: Ecto.DateTime.cast({{2016, 1, 1}, {0, 0, 0}}) |> elem(1))

      assert ward_result_latest.msg_id == SpadeInspector.get_last_ward_result_msg_id(ward_account.id)
    end

    test "with invalid ward_account id, returns nil" do
      assert nil == SpadeInspector.get_last_ward_result_msg_id(0)
    end

    test "if no results for a ward_account id, returns nil" do
      ward_account = insert(:ward_account)
      assert nil == SpadeInspector.get_last_ward_result_msg_id(ward_account.id)
    end
  end

  ###########
  # Backend #
  ###########

  describe "list_backends/0" do
    test "returns all backends" do
      backends = insert_list(3, :backend)
      results = SpadeInspector.list_backends()

      assert results |> length == backends |> length
    end

    test "returns the correct backends" do
      backend = insert(:backend)
      [result] = SpadeInspector.list_backends()

      assert backend.module == result.module
    end

    test "returns empty list if no backends exist" do
      results = SpadeInspector.list_backends()

      assert [] == results
    end
  end
end
