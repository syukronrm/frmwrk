defmodule Frmwrk.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string
      add :email, :string, null: false
      add :token, :string
      add :provider, :string

      timestamps()
    end

    create unique_index :users, [:email], unique: true
  end
end
