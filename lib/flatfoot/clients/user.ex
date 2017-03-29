defmodule Flatfoot.Clients.User do
  use Ecto.Schema

  schema "clients_users" do
    field :email, :string
    field :password_hash, :string
    field :username, :string

    timestamps()
  end
end
