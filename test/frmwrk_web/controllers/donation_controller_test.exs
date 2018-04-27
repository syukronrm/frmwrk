defmodule FrmwrkWeb.DonationControllerTest do
  use FrmwrkWeb.ConnCase

  import Frmwrk.Factory

  @valid_attrs %{amount: 100000}
  @invalid_attrs %{amount: 100}

  def fixture(:campaign) do
    user = insert(:user)
    campaign = insert(:campaign, %{title: "Menjadi Supermen", user: user})

    {:ok, campaign: campaign}
  end

  describe "show" do
    setup [:create_campaign]

    test "show donate button", %{conn: conn, campaign: campaign} do
      conn = get conn, campaign_path(conn, :show, campaign.url)

      assert html_response(conn, 200) =~ donation_path(conn, :new, campaign.url)
    end

    test "show input form", %{conn: conn, campaign: campaign} do
      conn = get conn, donation_path(conn, :new, campaign.url)

      assert html_response(conn, 200) =~ donation_path(conn, :create, campaign.url)
    end

    test "redirect to campaign index when campaign is not found", %{conn: conn, campaign: _} do
      conn = get conn, donation_path(conn, :new, "fake_campaign")

      assert get_flash(conn, :error) == "Kampanye tidak ditemukan"
      assert redirected_to(conn, 302) == campaign_path(conn, :index)
    end
  end

  describe "new" do
    setup [:create_campaign]
    
    @tag post_donation: "true"
    test "post donation to campaign", %{conn: conn, campaign: campaign} do
      user = insert(:user)

      conn =
        conn
        |> assign(:user, user)
        |> post(donation_path(conn, :create, campaign.url), %{donation: @valid_attrs})

      assert html_response(conn, 200) =~ ~r/konfirmasi/i
      assert html_response(conn, 200) =~ ~r/batal/i
    end

    test "redirected to input when value is invalid", %{conn: conn, campaign: campaign} do
      user = insert(:user)

      conn =
        conn
        |> assign(:user, user)
        |> post(donation_path(conn, :create, campaign.url), %{donation: @invalid_attrs})

      assert get_flash(conn, :info) =~ "Pastikan donasi Anda lebih dari Rp. 20.000,-"
      assert html_response(conn, 200) =~ ~r/masukkan nominal/i
    end
  end

  defp create_campaign(_) do
    fixture(:campaign)
  end
end
