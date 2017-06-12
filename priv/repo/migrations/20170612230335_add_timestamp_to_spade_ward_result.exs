defmodule Flatfoot.Repo.Migrations.AddTimestampToSpadeWardResult do
  use Ecto.Migration

  def change do
    alter table(:spade_ward_results) do
      add :timestamp, :timestamp
    end
  end
end
