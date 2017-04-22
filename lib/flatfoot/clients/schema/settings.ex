defmodule Flatfoot.Clients.Settings do
  use Ecto.Schema

  schema "clients_settings" do
    field :global_threshold, :integer, default: 0
    belongs_to :user, Flatfoot.Clients.User
    has_many :blackout_options, Flatfoot.Clients.BlackoutOption, on_delete: :delete_all

    timestamps()
  end
end
