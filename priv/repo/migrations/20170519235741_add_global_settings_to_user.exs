defmodule Flatfoot.Repo.Migrations.AddGlobalSettingsToUser do
  use Ecto.Migration

  def change do
    alter table(:clients_users) do
      add :global_threshold, :integer
    end
  end
end
