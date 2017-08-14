defmodule Flatfoot.Clients.BlackoutOption do
  use Ecto.Schema

  schema "blackout_options" do
    field :start, Ecto.Time
    field :stop, Ecto.Time
    field :threshold, :integer, default: 100
    field :exclude, :string
    belongs_to :user, Flatfoot.Clients.User

    timestamps()
  end
end
