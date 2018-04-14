defmodule Frmwrk.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :amount, :integer
      add :verified_at, :date
      add :unique_number, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :campaign_id, references(:campaigns, on_delete: :nothing)

      timestamps()
    end

    create index(:donations, [:user_id])
  end
end
