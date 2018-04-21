defmodule Frmwrk.Plugs.SetUser do
  import Plug.Conn

  alias Frmwrk.Auth.Guardian

  def init(_params) do
  end

  def call(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    conn
    |> assign(:user, current_user)
  end
end
