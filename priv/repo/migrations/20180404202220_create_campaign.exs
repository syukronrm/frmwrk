defmodule Frmwrk.Repo.Migrations.CreateCampaign do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add :title, :string, null: false
      add :image_url, :string
      add :short_description, :string
      add :description, :text
      add :deadline, :date
      add :url, :string
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end

    create unique_index :campaigns, [:url], unique: true
  end
end
