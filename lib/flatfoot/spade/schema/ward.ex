defmodule Flatfoot.Spade.Ward do
  use Ecto.Schema

  schema "wards" do
    belongs_to :user, Flatfoot.Spade.User
    has_many :ward_accounts, Flatfoot.Spade.WardAccount, on_delete: :delete_all

    field :name, :string
    field :relationship, :string
    field :active, :boolean, default: true

    timestamps()
  end
end
