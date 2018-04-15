# TODO
# OK create_login: POST /login
#   OK check user
#   - insert to session
# OK create
#   OK redirect to set password if password empty

defmodule FrmwrkWeb.AuthController do
  use FrmwrkWeb, :controller
  plug Ueberauth

  alias Frmwrk.Auth.User
  alias Frmwrk.Auth
  alias Frmwrk.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      token: auth.credentials.token,
      name: "#{auth.info.first_name} #{auth.info.last_name}",
      email: auth.info.email,
      provider: "google"
    }

    changeset = User.changeset(%User{}, user_params)

    create(conn, changeset)
  end

  def create(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        case User.password_exist?(User, user) do
          true ->
            conn
            |> put_flash(:info, "Thank you for signing in!")
            |> put_session(:user_id, user.id)
            |> redirect(to: page_path(conn, :index))
          _ ->
            conn
            |> put_flash(:info, "Buat password terlebih dahulu")
            |> put_session(:user_id, user.id)
            |> redirect(to: auth_path(conn, :password))
        end

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

  def password(conn, _params) do
    changeset = Auth.change_user(%User{})
    render conn, "set_password.html", changeset: changeset
  end

  def set_password(conn, %{"user" => user_params}) do
    %{"password" => password, "password_again" => password_again} = user_params

    case password == password_again do
      false ->
        conn
        |> put_flash(:error, "Pastikan Anda mengetik password yang sama")
        |> redirect(to: auth_path(conn, :password))

      _ ->
        Auth.get_user!(conn.assigns.user.id)
        |> Auth.change_user
        |> Auth.change_password(password)
        |> Auth.apply_user

        conn
        |> put_flash(:info, "Terima kasih, password berhasil dibuat")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def login(conn, _params) do
    changeset = Auth.change_user(%User{})
    render conn, "login.html", changeset: changeset
  end

  def create_login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case User.check_creds(email, password) do
      {:ok} ->
        conn
        |> put_flash(:info, "You're now logged in!")
        |> redirect(to: page_path(conn, :index))

      {:error, _reason} ->
        changeset = Auth.change_user(%User{})

        conn
        |> put_flash(:error, "Invalid email/password")
        |> render("login.html", changeset: changeset)
    end
  end
end
