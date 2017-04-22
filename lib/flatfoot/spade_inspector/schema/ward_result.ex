defmodule Flatfoot.SpadeInspector.WardResult do
  use Ecto.Schema

  schema "spade_ward_results" do
    field :ward_id, :integer
    field :backend_id, :integer

    field :rating, :integer
    field :from, :string
    field :msg_id, :string
    field :msg_text, :string

    timestamps()
  end
end
