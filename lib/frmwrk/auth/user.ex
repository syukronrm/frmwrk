defmodule Frmwrk.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :name, :string
    field :provider, :string
    field :role, :integer
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :token, :provider, :role])
    |> validate_required([:name, :email, :token, :provider, :role])
    |> unique_constraint(:email)
  end
end
