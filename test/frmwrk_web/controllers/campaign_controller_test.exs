defmodule FrmwrkWeb.CampaignControllerTest do
  use FrmwrkWeb.ConnCase

  import Frmwrk.Factory

  alias Frmwrk.Campaign

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
  end

  describe "new video" do
    setup [:create_campaign]
    
    test "show create new campaign page", %{conn: conn} do
      conn = get conn, campaign_path(conn, :new)

      assert html_response(conn, 200) =~ "Membuat campaign"
    end
  end

  defp create_campaign(_) do
    fixture(:campaign)
  end
end
