defmodule Frmwrk.Repo.Migrations.AddUserColumns do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :password, :text
      add :role, :integer
    end
  end
end
