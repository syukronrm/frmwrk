defmodule FrmwrkWeb.CampaignControllerTest do
  use FrmwrkWeb.ConnCase

  import Frmwrk.Factory

  @valid_attrs %{
    title: "Campaign Test",
    description: "Describe Me",
    image_url: "http://via.placeholder.com/350x250",
    url: "describeme",
  }

  @invalid_attrs %{url: "randomurl"}

  def fixture(:campaign) do
    user = insert(:user)
    campaign = insert(:campaign, %{title: "Menjadi Supermen", user: user})

    {:ok, campaign: campaign, user: user}
  end

  describe "index" do
    setup [:create_campaign]

    test "show campaigns", %{conn: conn} do
      conn = get conn, campaign_path(conn, :index)

      assert html_response(conn, 200) =~ "Lihat"
      assert html_response(conn, 200) =~ "Menjadi Supermen"
    end

    test "show one campaign by url", %{conn: conn, campaign: campaign} do
      conn = get conn, campaign_path(conn, :show, campaign.url)

      assert html_response(conn, 200) =~ campaign.title
      assert html_response(conn, 200) =~ campaign.description
    end

    test "redirect when url not found", %{conn: conn} do
      conn = get conn, campaign_path(conn, :show, @invalid_attrs.url)

      assert redirected_to(conn) == campaign_path(conn, :index)
      assert get_flash(conn, :error) == "Kampanye tidak ditemukan"
    end
  end

  describe "new video" do
    setup [:create_campaign]

    test "show create new campaign page", %{conn: conn} do
      conn = get conn, campaign_path(conn, :new)

      assert html_response(conn, 200) =~ "Membuat campaign"
      assert html_response(conn, 200) =~ "Judul"
      assert html_response(conn, 200) =~ "Deskripsi"
      assert html_response(conn, 200) =~ "Alamat URL singkat"
    end

    test "redirect to show when data is valid", %{conn: conn} do
      user = insert :user

      campaign = Map.put(@valid_attrs, :user_id, user.id)

      conn =
        conn
        |> assign(:user, user)
        |> post(campaign_path(conn, :create), campaign: campaign)

      lastInserted = Frmwrk.Campaign |> Ecto.Query.last() |> Frmwrk.Repo.one
      assert redirected_to(conn) == campaign_path(conn, :show, campaign.url)
      assert campaign.url == lastInserted.url
    end

    test "back to page new campaign when data is invalid", %{conn: conn} do
      user = insert :user

      campaign = @invalid_attrs

      conn =
        conn
        |> assign(:user, user)
        |> post(campaign_path(conn, :create), campaign: campaign)

      assert html_response(conn, 200) =~ "Membuat campaign"
      assert get_flash(conn, :error) =~ "Data tidak sesuai"
    end
  end

  defp create_campaign(_) do
    fixture(:campaign)
  end
end
