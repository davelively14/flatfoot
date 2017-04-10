defmodule Flatfoot.Spade.Target do
  use Ecto.Schema

  schema "spade_targets" do
    belongs_to :user, Flatfoot.Spade.User

    field :name, :string
    field :relationship, :string
    field :active, :boolean, default: true

    timestamps()
  end
end
