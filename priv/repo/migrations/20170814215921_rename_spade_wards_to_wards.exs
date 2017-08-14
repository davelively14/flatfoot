defmodule Flatfoot.Repo.Migrations.RenameSpadeWardsToWards do
  use Ecto.Migration

  def change do
    rename table(:spade_wards), to: table(:wards)
  end
end
