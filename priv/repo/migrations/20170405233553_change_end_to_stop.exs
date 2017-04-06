defmodule Flatfoot.Repo.Migrations.ChangeEndToStop do
  use Ecto.Migration

  def change do
    alter table(:clients_blackout_options) do
      remove :end
      add :stop, :time
    end
  end
end
