defmodule Flatfoot.SpadeInspector.WardResult do
  use Ecto.Schema

  schema "spade_ward_results" do
    # field :ward_account_id, :integer
    belongs_to :ward_account, Flatfoot.Spade.WardAccount
    belongs_to :backend, Flatfoot.SpadeInspector.Backend

    field :rating, :integer
    field :from, :string
    field :from_id, :string
    field :msg_id, :string
    field :msg_text, :string
    field :timestamp, Ecto.DateTime

    timestamps()
  end
end
