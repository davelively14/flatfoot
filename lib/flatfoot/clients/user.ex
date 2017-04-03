defmodule Flatfoot.Clients.User do
  use Ecto.Schema

  schema "clients_users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :username, :string
    has_many :sessions, Flatfoot.Clients.Session, on_delete: :delete_all
    has_many :notification_records, Flatfoot.Clients.NotificationRecord, on_delete: :delete_all

    timestamps()
  end
end
