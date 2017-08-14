defmodule Flatfoot.SpadeInspector.Backend do
  use Ecto.Schema

  schema "backends" do
    field :module, :string

    timestamps()
  end
end
