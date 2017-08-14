defmodule Flatfoot.Clients.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :username, :string
    field :global_threshold, :integer, default: 0
    has_many :sessions, Flatfoot.Clients.Session, on_delete: :delete_all
    has_many :notification_records, Flatfoot.Clients.NotificationRecord, on_delete: :delete_all
    has_many :blackout_options, Flatfoot.Clients.BlackoutOption, on_delete: :delete_all

    timestamps()
  end
end
