defmodule Flatfoot.SpadeInspector.WardResult do
  use Ecto.Schema

  schema "ward_results" do
    field :ward_account_id, :integer
    field :backend_id, :integer

    field :rating, :integer
    field :from, :string
    field :from_id, :string
    field :msg_id, :string
    field :msg_text, :string
    field :timestamp, Ecto.DateTime

    timestamps()
  end
end
