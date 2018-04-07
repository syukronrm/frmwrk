defmodule Frmwrk.Repo.Migrations.AddDonationsTable do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :amount, :integer
      add :verified_at, :naive_datetime
      add :user_id, references(:users)
      add :campaign_id, references(:campaigns)

      timestamps()
    end
  end
end
