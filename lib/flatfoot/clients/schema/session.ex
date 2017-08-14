defmodule Flatfoot.Clients.Session do
  use Ecto.Schema

  schema "sessions" do
    field :token, :string
    belongs_to :user, Flatfoot.Clients.User

    timestamps()
  end
end
