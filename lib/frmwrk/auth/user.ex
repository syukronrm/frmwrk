defmodule Frmwrk.Auth.User do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Ecto.Changeset
  alias Frmwrk.Repo

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:provider, :string)
    field(:role, :integer, default: 4)
    field(:token, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:password_confirmation, :string, virtual: true)

    has_many(:campaigns, Frmwrk.Campaigns.Campaign)
    has_many(:comments, Frmwrk.Campaigns.Comment)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :token, :provider, :role, :password, :password_hash])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end

  def registration_changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:name, min: 3)
    |> unique_constraint(:email)
    |> hashing_password()
  end

  defp hashing_password(%Changeset{valid?: valid?} = changeset) when valid? do
    changeset
    |> put_change(:password_hash,
                  Comeonin.Bcrypt.hashpwsalt(changeset.changes.password))
  end
  defp hashing_password(changeset), do: changeset

  def check_creds_(%{email: email, password: password}) do
    email_downcase = String.downcase(email)

    query = from(u in __MODULE__, where: u.email == ^email_downcase)
    user = Repo.one(query)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end
  def check_creds_(_), do: {:error, :not_found}

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
    query = from(u in __MODULE__, where: u.email == ^email)
    user = Repo.one(query)

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

  def set_password(%Changeset{} = changeset) do
    with password <- get_field(changeset, :password)
    do
      changeset
      |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(password))
    end
  end
end
