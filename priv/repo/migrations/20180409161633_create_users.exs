defmodule Frmwrk.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :token, :string
      add :provider, :string
      add :role, :integer
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
