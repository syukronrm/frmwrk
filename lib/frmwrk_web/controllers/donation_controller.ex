defmodule FrmwrkWeb.DonationController do
  use FrmwrkWeb, :controller

  alias Frmwrk.Campaigns
  alias Frmwrk.Campaigns.Donation
  alias Frmwrk.Auth.{Guardian, User}

  plug(:check_campaign_url)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.campaign]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, campaign) do
    changeset = Campaigns.change_donation(%Campaigns.Donation{})

    conn
    |> render("new.html", changeset: changeset, campaign: campaign)
  end

  def create(conn, %{"donation" => donation_params}, campaign) do
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

  def confirm(conn, %{"amount" => amount, "action" => action}, campaign) do
    case Donation.donation_to_confirm(amount) do
      nil ->
        conn
        |> put_flash(:info, "Donasi tidak ditemukan")
        |> redirect(to: campaign_path(conn, :show, campaign.url))

      donation ->
        Donation.confirm_donation(donation, action)

        conn
        |> put_flash(:info, "Terima kasih atas donasi Anda")
        |> redirect(to: campaign_path(conn, :show, campaign.url))
    end
  end

  defp check_campaign_url(%Plug.Conn{path_params: %{"url" => url}} = conn, _options) do
    case Campaigns.get_campaign_by_url(url) do
      nil ->
        conn
        |> put_flash(:error, "Kampanye tidak ditemukan")
        |> redirect(to: campaign_path(conn, :index))
        |> halt()

      campaign ->
        conn
        |> assign(:campaign, campaign)
    end
  end
end
