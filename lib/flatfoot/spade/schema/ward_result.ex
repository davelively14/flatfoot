defmodule Flatfoot.Spade.WardResult do
  use Ecto.Schema

  schema "spade_ward_results" do
    belongs_to :ward, Flatfoot.Spade.Ward
    belongs_to :backend, Flatfoot.Spade.Backend

    field :rating, :integer
    field :from, :string
    field :msg_id, :string
    field :msg_text, :string

    timestamps()
  end
end
