defmodule Flatfoot.Repo.Migrations.RenameSpadeWardResultsToWardResults do
  use Ecto.Migration

  def change do
    rename table(:spade_ward_results), to: table(:ward_results)
  end
end
