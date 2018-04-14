defmodule Frmwrk.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :provider, :string
    field :role, :integer, default: 4
    field :token, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :campaigns, Frmwrk.Campaigns.Campaign
    has_many :comments, Frmwrk.Campaigns.Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :token, :provider, :role])
    |> validate_required([:name, :email, :token, :provider])
    |> unique_constraint(:email)
  end

  def type(user) do
    case user do
      :super_admin -> 1
      :admin -> 2
      :campaigner -> 3
      :donatur -> 4
    end
  end

  def hash_password(changeset, password) do
    changeset
    |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(password))
  end
end
