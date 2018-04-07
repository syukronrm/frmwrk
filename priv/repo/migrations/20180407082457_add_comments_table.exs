defmodule Frmwrk.Repo.Migrations.AddCommentsTable do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :text
      add :user_id, references(:users)
      add :campaign_id, references(:campaigns)

      timestamps()
    end
  end
end
