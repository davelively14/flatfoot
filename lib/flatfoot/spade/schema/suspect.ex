defmodule Flatfoot.Spade.Suspect do
  use Ecto.Schema

  schema "suspects" do
    belongs_to :watchlist, Flatfoot.Spade.Watchlist
    has_many :suspect_accounts, Flatfoot.Spade.SuspectAccount, on_delete: :delete_all

    field :name, :string
    field :category, :string
    field :notes, :string
    field :active, :boolean, default: true

    timestamps()
  end
end
