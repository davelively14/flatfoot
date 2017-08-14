defmodule Flatfoot.Spade.User do
  use Ecto.Schema

  schema "users" do
    has_many :watchlists, Flatfoot.Spade.Watchlist, on_delete: :delete_all
    has_many :wards, Flatfoot.Spade.Ward, on_delete: :delete_all
    field :email, :string
    field :username, :string
    field :global_threshold, :integer

    timestamps()
  end
end
