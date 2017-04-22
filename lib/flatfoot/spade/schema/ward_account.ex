defmodule Flatfoot.Spade.WardAccount do
  use Ecto.Schema

  schema "spade_ward_accounts" do
    belongs_to :ward, Flatfoot.Spade.Ward
    belongs_to :backend, Flatfoot.Spade.Backend

    field :handle, :string

    timestamps()
  end
end
