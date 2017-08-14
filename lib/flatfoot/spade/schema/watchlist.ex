defmodule Flatfoot.Spade.Watchlist do
  use Ecto.Schema

  schema "watchlists" do
    belongs_to :user, Flatfoot.Spade.User
    has_many :suspects, Flatfoot.Spade.Suspect, on_delete: :delete_all

    field :name, :string

    timestamps()
  end
end
