defmodule Flatfoot.Clients.BlackoutOption do
  use Ecto.Schema

  schema "clients_blackout_options" do
    field :start, Ecto.Time
    field :end, Ecto.Time
    field :threshold, :integer, default: 100
    field :exclude, :string
    belongs_to :settings, Flatfoot.Clients.Settings

    timestamps()
  end
end
