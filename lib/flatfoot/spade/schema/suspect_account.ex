defmodule Flatfoot.Spade.SuspectAccount do
  use Ecto.Schema

  schema "suspect_accounts" do
    belongs_to :suspect, Flatfoot.Spade.Suspect
    belongs_to :backend, Flatfoot.Spade.Backend

    field :handle, :string

    timestamps()
  end
end
