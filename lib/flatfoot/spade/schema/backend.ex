defmodule Flatfoot.Spade.Backend do
  use Ecto.Schema

  schema "backends" do
    has_many :ward_accounts, Flatfoot.Spade.WardAccount, on_delete: :delete_all

    field :name, :string
    field :url, :string
    field :module, :string

    timestamps()
  end
end
