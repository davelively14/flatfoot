defmodule Flatfoot.Spade.Watchlist do
  use Ecto.Schema

  schema "spade_watchlists" do
    belongs_to :user, Flatfoot.Spade.User
    # has_many :wards, Flatfoot.Spade.Ward, on_delete: :delete_all

    field :name, :string

    timestamps()
  end
end
