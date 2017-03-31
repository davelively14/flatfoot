defmodule Flatfoot.Repo.Migrations.CreateClientsSession do
  use Ecto.Migration

  def change do
    create table(:clients_sessions) do
      add :token, :string
      add :user_id, references(:clients_users, on_delete: :nothing)

      timestamps()
    end

    create index(:clients_sessions, [:user_id])
    create index(:clients_sessions, [:token])
  end
end
