require IEx

defmodule FrmwrkWeb.CampaignController do
  use FrmwrkWeb, :controller

  alias Frmwrk.Repo
  alias Frmwrk.Campaign

  def index(conn, _params) do
    campaigns = Repo.all Campaign
    render conn, "index.html", campaigns: campaigns
  end

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, _params) do
    render conn, "create.html"
  end
end
