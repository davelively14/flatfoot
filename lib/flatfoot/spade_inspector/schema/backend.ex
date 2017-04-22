defmodule Flatfoot.SpadeInspector.Backend do
  use Ecto.Schema

  schema "archer_backends" do
    field :module, :string

    timestamps()
  end
end
