defmodule Flatfoot.Archer.Backend do
  use Ecto.Schema

  schema "backends" do
    field :name, :string
    field :name_snake, :string
    field :url, :string
    field :module, :string

    timestamps()
  end
end
