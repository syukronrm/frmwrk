defmodule Frmwrk.Repo.Migrations.CreateCampaign do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add :title, :string
      add :image_url, :string
      add :description, :string
      add :deadline, :date
      add :user_id, references(:users)

      timestamps()
    end
  end
end
