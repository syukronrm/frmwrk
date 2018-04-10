defmodule Frmwrk.Repo.Migrations.CreateCampaigns do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add :title, :string
      add :short_description, :string
      add :description, :text
      add :deadline, :date
      add :url, :string
      add :image, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:campaigns, [:user_id])
  end
end
