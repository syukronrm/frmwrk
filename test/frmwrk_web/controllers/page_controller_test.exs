defmodule FrmwrkWeb.PageControllerTest do
  use FrmwrkWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Infaqkan sebagian harga Anda"
  end
end
