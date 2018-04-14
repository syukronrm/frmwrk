defmodule FrmwrkWeb.DonationControllerTest do
  use FrmwrkWeb.ConnCase

  import Frmwrk.Factory

  @valid_attrs %{amount: 10000}
  @invalid_attrs_1 %{amount: 100}
  @invalid_attrs_2 %{amount: ""}

  def fixture(:campaign) do
    user = insert(:user)
    campaign = insert(:campaign, %{title: "Menjadi Supermen", user: user})

    {:ok, campaign: campaign}
  end

  describe "show" do
    setup [:create_campaign]

    test "show donate button", %{conn: conn, campaign: campaign} do
      conn = get conn, campaign_path(conn, :new, campaign.url)

      assert html_response(conn, 200) =~ "Donasi"
    end

    test "show input form", %{conn: conn, campaign: campaign} do
      conn = get conn, campaign_path(conn, :donation_new, campaign.url)

      assert html_response(conn, 200) =~ "name=\"donation[amount]\""
    end
  end

  describe "new" do
    setup [:create_campaign]

    test "post donation to campaign", %{conn: conn, campaign: campaign} do
      user = insert(:user)

      conn =
        conn
        |> assign(:user, user)
        |> post(campaign_path(conn, :campaign_confirm, campaign.url), @valid_attrs)

      assert html_response(conn, 200) =~ ~r/konfirmasi/i
      assert html_response(conn, 200) =~ ~r/transfer/i
      assert html_response(conn, 200) =~ ~r/donasi sekarang/i
    end

    test "redirected to input when value is invalid", %{conn: conn, campaign: campaign} do
      user = insert(:user)

      conn =
        conn
        |> assign(:user, user)
        |> post(campaign_path(conn, :campaign_confirm, campaign.url), @invalid_attrs)

      assert get_flash(conn, :info) =~ "Masukkan nominal lebih dari Rp. 10.0000"
      assert redirected_to(conn, 302) == campaign_path(conn, :campaign_new, campaign.url)
    end

    test "redirected to campaign page when donation is success", %{conn: conn, campaign: campaign} do
      user = insert(:user)

      conn =
        conn
        |> assign(:user, user)
        |> post(campaign_path(conn, :campaign_create, campaign.url), @valid_attrs)

      assert get_flash(conn, :info) =~ "Terima kasih atas donasi Anda"
      assert redirected_to(conn, 302) == campaign_path(conn, :campaign_new, campaign.url)
    end
  end

  defp create_campaign(_) do
    campaign = fixture(:campaign)
  end
end
