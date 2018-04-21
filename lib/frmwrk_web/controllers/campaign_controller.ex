defmodule FrmwrkWeb.CampaignController do
  use FrmwrkWeb, :controller

  alias Frmwrk.Campaigns
  alias Frmwrk.Campaigns.Campaign
  alias Frmwrk.Campaigns.Donation
  alias Frmwrk.Auth.User

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
        render conn, "show.html", campaign: campaign
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

  def donation_new(conn, %{"url" => url}) do
    case Campaigns.get_campaign_by_url(url) do
      nil ->
        conn
        |> put_flash(:error, "Kampanye tidak ditemukan")
        |> redirect(to: campaign_path(conn, :index))
      campaign ->
        changeset = Campaigns.change_donation(%Campaigns.Donation{})
        conn
        |> render("donation_new.html", changeset: changeset, campaign: campaign)
    end
  end

  def donation_create(conn, %{"url" => url, "donation" => donation_params}) do
    case Campaigns.get_campaign_by_url(url) do
      nil ->
        conn
        |> put_flash(:error, "Kampanye tidak ditemukan")
        |> redirect(to: campaign_path(conn, :index))
      campaign ->
        user =
          if conn.assigns.user do
            conn.assigns.user
          else
            %User{}
          end

        case Campaigns.create_donation(donation_params, campaign, user) do
          {:ok, donation} ->
            conn
            |> render("donation_confirm.html", donation: donation, campaign: campaign)
          {:error, changeset} ->
            conn
            |> put_flash(:info, "Pastikan donasi Anda lebih dari Rp. 20.000,-")
            |> render("donation_new.html", changeset: changeset, campaign: campaign)
        end
    end
  end

  def donation_confirm(conn, %{"url" => url, "amount" => amount, "action" => action}) do
    case Campaigns.get_campaign_by_url(url) do
      nil ->
        conn
        |> put_flash(:error, "Kampanye tidak ditemukan")
        |> redirect(to: campaign_path(conn, :index))
      campaign ->
        case Donation.donation_to_confirm(amount) do
          nil ->
            conn
            |> put_flash(:info, "Donasi tidak ditemukan")
            |> redirect(to: campaign_path(conn, :show, campaign.url))
          donation ->
            Donation.confirm_donation(donation, action)

            conn
            |> put_flash(:info, "Terima kasih atas Donasi Anda")
            |> redirect(to: campaign_path(conn, :show, campaign.url))
        end
    end
  end
end
