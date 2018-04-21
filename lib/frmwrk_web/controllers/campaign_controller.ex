defmodule FrmwrkWeb.CampaignController do
  use FrmwrkWeb, :controller

  alias Frmwrk.Campaigns
  alias Frmwrk.Campaigns.Campaign

  def index(conn, _params) do
    campaigns = Campaigns.list_campaigns()
    render(conn, "index.html", campaigns: campaigns)
  end

  def new(conn, _params) do
    changeset = Campaigns.change_campaign(%Campaign{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"campaign" => campaign_params}) do
    case Campaigns.create_campaign(campaign_params) do
      {:ok, campaign} ->
        conn
        |> put_flash(:info, "Campaign created successfully.")
        |> redirect(to: campaign_path(conn, :show, campaign.url))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Data tidak sesuai")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"url" => url}) do
    case Campaigns.get_campaign_by_url(url) do
      nil ->
        conn
        |> put_flash(:error, "Kampanye tidak ditemukan")
        |> redirect(to: campaign_path(conn, :index))

      campaign ->
        render(conn, "show.html", campaign: campaign)
    end
  end

  def update(conn, %{"id" => id, "campaign" => campaign_params}) do
    campaign = Campaigns.get_campaign!(id)

    case Campaigns.update_campaign(campaign, campaign_params) do
      {:ok, campaign} ->
        conn
        |> put_flash(:info, "Campaign updated successfully.")
        |> redirect(to: campaign_path(conn, :show, campaign))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", campaign: campaign, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    campaign = Campaigns.get_campaign!(id)
    {:ok, _campaign} = Campaigns.delete_campaign(campaign)

    conn
    |> put_flash(:info, "Campaign deleted successfully.")
    |> redirect(to: campaign_path(conn, :index))
  end
end
