defmodule Flatfoot.Spade.Backend do
  use Ecto.Schema

  schema "archer_backends" do
    has_many :ward_accounts, Flatfoot.Spade.WardAccount, on_delete: :delete_all
    
    field :name, :string
    field :url, :string

    timestamps()
  end
end
