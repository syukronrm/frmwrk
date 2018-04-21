require IEx

defmodule FrmwrkWeb.PageController do
  use FrmwrkWeb, :controller

  def index(conn, _params) do
    # IEx.pry
    render(conn, "index.html")
  end
end
