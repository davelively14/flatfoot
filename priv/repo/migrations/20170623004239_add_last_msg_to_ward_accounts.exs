defmodule Flatfoot.Repo.Migrations.AddLastMsgToWardAccounts do
  use Ecto.Migration

  def change do
    alter table(:spade_ward_accounts) do
      add :last_msg, :string
    end
  end
end
