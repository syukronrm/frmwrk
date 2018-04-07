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

  def show(conn, %{"url" => url}) do
    campaign = Repo.get_by Campaign, url: url

    case campaign do
      nil ->
        conn
        |> put_flash(:error, "Kampanye tidak ditemukan")
        |> redirect(to: campaign_path(conn, :index))

      _ ->
        render conn, "show.html", campaign: campaign
    end
  end

  def create(conn, %{"campaign" => campaign_params}) do
    changeset = Campaign.changeset(%Campaign{}, campaign_params)

    case Repo.insert changeset do
      {:ok, campaign} ->
        conn
        |> put_flash(:info, "Kampanye berhasil dibuat")
        |> redirect(to: campaign_path(conn, :show, campaign.url))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Data tidak sesuai")
        |> render("new.html", changeset: changeset)
    end
  end
end
