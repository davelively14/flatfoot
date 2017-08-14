defmodule Flatfoot.Repo.Migrations.RenameSpadeSuspectsToSuspects do
  use Ecto.Migration

  def change do
    rename table(:spade_suspects), to: table(:suspects)
  end
end
