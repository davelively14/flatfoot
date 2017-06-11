defmodule Flatfoot.Repo.Migrations.AddFromIdToWardResults do
  use Ecto.Migration

  def change do
    alter table(:spade_ward_results) do
      add :from_id, :string
    end
  end
end
