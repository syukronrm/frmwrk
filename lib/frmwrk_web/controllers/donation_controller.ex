defmodule FrmwrkWeb.DonationController do
  use FrmwrkWeb, :controller

  alias Frmwrk.Campaigns
  alias Frmwrk.Campaigns.Donation
  alias Frmwrk.Auth.{Guardian, User}

  def new(conn, %{"url" => url}) do
    case Campaigns.get_campaign_by_url(url) do
      nil ->
        conn
        |> put_flash(:error, "Kampanye tidak ditemukan")
        |> redirect(to: campaign_path(conn, :index))
      campaign ->
        changeset = Campaigns.change_donation(%Campaigns.Donation{})
        conn
        |> render("new.html", changeset: changeset, campaign: campaign)
    end
  end

  def create(conn, %{"url" => url, "donation" => donation_params}) do
    case Campaigns.get_campaign_by_url(url) do
      nil ->
        conn
        |> put_flash(:error, "Kampanye tidak ditemukan")
        |> redirect(to: campaign_path(conn, :index))
      campaign ->
        user =
          if Guardian.Plug.authenticated?(conn) do
            conn.assigns.user
          else
            %User{}
          end

        case Campaigns.create_donation(donation_params, campaign, user) do
          {:ok, donation} ->
            conn
            |> render("confirm.html", donation: donation, campaign: campaign)
          {:error, changeset} ->
            conn
            |> put_flash(:info, "Pastikan donasi Anda lebih dari Rp. 20.000,-")
            |> render("new.html", changeset: changeset, campaign: campaign)
        end
    end
  end

  def confirm(conn, %{"url" => url, "amount" => amount, "action" => action}) do
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
