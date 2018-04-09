defmodule Frmwrk.Repo.Migrations.AddCommentsTable do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :campaign_id, references(:campaigns, on_delete: :delete_all)

      timestamps()
    end
  end
end
