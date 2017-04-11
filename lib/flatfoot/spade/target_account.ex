defmodule Flatfoot.Spade.TargetAccount do
  use Ecto.Schema

  schema "spade_target_accounts" do
    belongs_to :target, Flatfoot.Spade.Target
    belongs_to :backend, Flatfoot.Spade.Backend

    field :handle, :string

    timestamps()
  end
end
