defmodule Flatfoot.Spade.Backend do
  use Ecto.Schema

  schema "archer_backends" do
    field :name, :string
    field :url, :string
    has_many :target_accounts, Flatfoot.Spade.TargetAccount, on_delete: :delete_all

    timestamps()
  end
end
