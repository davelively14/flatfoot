defmodule Flatfoot.Spade.User do
  use Ecto.Schema

  schema "clients_users" do
    field :email, :string
    field :username, :string

    timestamps()
  end
end
