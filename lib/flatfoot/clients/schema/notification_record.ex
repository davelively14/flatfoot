defmodule Flatfoot.Clients.NotificationRecord do
  use Ecto.Schema

  schema "notification_records" do
    belongs_to :user, Flatfoot.Clients.User
    field :nickname, :string
    field :email, :string
    field :role, :string, default: nil
    field :threshold, :integer, default: 0

    timestamps()
  end
end
