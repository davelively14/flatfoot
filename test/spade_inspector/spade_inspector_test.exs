defmodule Flatfoot.SpadeInspectorTest do
  use Flatfoot.DataCase
  alias Flatfoot.SpadeInspector

  ###############
  # Ward Result #
  ###############

  describe "create_ward_result/1" do
    test "with valid attributes, will create a suspect account" do
      ward = insert(:ward)
      backend = insert(:backend)
      attrs = %{
        rating: Enum.random(0..100),
        from: Faker.Internet.user_name,
        msg_id: Enum.random(1000..1999) |> to_string,
        msg_text: Faker.Lorem.Shakespeare.hamlet,
        ward_id: ward.id,
        backend_id: backend.id
      }

      {:ok, result} = SpadeInspector.create_ward_result(attrs)
      assert result.rating == attrs.rating
      assert result.msg_id == attrs.msg_id
      assert result.msg_text == attrs.msg_text
      assert result.from == attrs.from
      assert result.backend_id == attrs.backend_id
      assert result.ward_id == attrs.ward_id
    end

    test "with invalid attributes, will return a changeset with errors" do
      {:error, changeset} = SpadeInspector.create_ward_result(%{})

      assert changeset.errors[:rating] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:msg_id] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:msg_text] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:from] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:ward_id] == {"can't be blank", [validation: :required]}
      assert changeset.errors[:backend_id] == {"can't be blank", [validation: :required]}

      {:error, changeset} = SpadeInspector.create_ward_result(%{rating: 105})
      assert changeset.errors[:rating] == {"is invalid", [validation: :inclusion]}
    end
  end
end
