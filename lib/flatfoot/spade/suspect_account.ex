defmodule Flatfoot.Spade.SuspectAccount do
  use Ecto.Schema

  schema "spade_suspect_accounts" do
    belongs_to :suspect, Flatfoot.Spade.Suspect
    belongs_to :backend, Flatfoot.Archer.Backend

    field :handle, :string

    timestamps()
  end
end
