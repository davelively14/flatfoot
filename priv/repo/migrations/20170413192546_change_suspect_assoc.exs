defmodule Flatfoot.Repo.Migrations.ChangeSuspectAssoc do
  use Ecto.Migration

  def change do
    alter table(:spade_suspects) do
      remove :user_id
      add :watchlist_id, references(:spade_watchlists)
    end

    create index(:spade_suspects, [:watchlist_id])
  end
end
