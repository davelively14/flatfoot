defmodule Flatfoot.Spade.Suspect do
  use Ecto.Schema

  schema "spade_suspects" do
    belongs_to :watchlist, Flatfoot.Spade.Watchlist
    has_many :suspect_accounts, Flatfoot.Spade.SuspectAccount

    field :name, :string
    field :category, :string
    field :notes, :string
    field :active, :boolean, default: true

    timestamps()
  end
end
