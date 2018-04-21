defmodule Frmwrk.Auth.User do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Frmwrk.Repo

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

  def password_exist?(%__MODULE__{password_hash: password_hash} = _user) do
    case password_hash do
      nil ->
        false
      "" ->
        false
      _ ->
        true
    end
  end

  def check_creds(email, password) do
    query = from u in __MODULE__, where: u.email == ^email
    user = Repo.one query

    cond do
      password == nil ->
        {:error, :empty_password}
      user.password_hash == nil ->
        {:error, :password_had_not_set}
      user && checkpw(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end
end
