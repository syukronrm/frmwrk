defmodule Frmwrk.Repo.Migrations.AddDonationsTable do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :amount, :integer
      add :verified_at, :naive_datetime
      add :user_id, references(:users, on_delete: :delete_all)
      add :campaign_id, references(:campaigns, on_delete: :delete_all)

      timestamps()
    end
  end
end
