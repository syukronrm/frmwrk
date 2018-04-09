defmodule Frmwrk.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :role, :integer
    field :email, :string
    field :token, :string
    field :provider, :string

    has_many :campaigns, Frmwrk.Campaign

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :token, :provider])
    |> validate_required([:first_name, :last_name, :email, :token, :provider])
    |> unique_constraint(:email)
  end

  def type(num) do
    case num do
      :SUPER_ADMIN -> 1
      :ADMIN -> 2
      :CAMPAIGNER -> 3
      :DONATUR -> 4
    end
  end
end
