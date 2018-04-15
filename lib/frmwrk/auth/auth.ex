defmodule Frmwrk.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias Frmwrk.Repo

  alias Frmwrk.Auth.User
  alias Frmwrk.Auth.Guardian

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def apply_user(%Changeset{} = user) do
    user
    |> Repo.update()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def change_password(user, password) do
    user
    |> User.hash_password(password)
  end

  def login(conn, %User{} = user) do
    Guardian.Plug.sign_in(conn, user)
  end

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

  # @spec current_user(Plug.Conn) :: User
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
