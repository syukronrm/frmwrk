defmodule Frmwrk.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :amount, :integer
      add :verified_at, :date
      add :donatur_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:donations, [:donatur_id])
  end
end