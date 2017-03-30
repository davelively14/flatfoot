defmodule Flatfoot.Clients.User do
  use Ecto.Schema

  schema "clients_users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :username, :string

    timestamps()
  end
end
