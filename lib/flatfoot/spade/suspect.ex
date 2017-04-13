defmodule Flatfoot.Spade.Suspect do
  use Ecto.Schema

  schema "spade_suspects" do
    belongs_to :user, Flatfoot.Spade.User
    # has_many :suspect_accounts

    field :name, :string
    field :category, :string
    field :notes, :string
    field :active, :boolean, default: true

    timestamps()
  end
end
