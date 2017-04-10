defmodule Flatfoot.Spade.Target do
  use Ecto.Schema

  schema "spade_targets" do
    field :name, :string

    timestamps()
  end
end
