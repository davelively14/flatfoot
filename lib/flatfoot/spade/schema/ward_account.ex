defmodule Flatfoot.Spade.WardAccount do
  use Ecto.Schema

  schema "ward_accounts" do
    belongs_to :ward, Flatfoot.Spade.Ward
    belongs_to :backend, Flatfoot.Spade.Backend
    has_many :ward_results, Flatfoot.Spade.WardResult, on_delete: :delete_all

    field :handle, :string
    field :last_msg, :string

    timestamps()
  end
end
