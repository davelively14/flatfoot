defmodule Flatfoot.Spade.Backend do
  use Ecto.Schema

  schema "archer_backends" do
    has_many :target_accounts, Flatfoot.Spade.TargetAccount, on_delete: :delete_all
    
    field :name, :string
    field :url, :string

    timestamps()
  end
end
