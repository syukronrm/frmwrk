defmodule FrmwrkWeb.CommentControllerText do
  use FrmwrkWeb.ConnCase

  import Frmwrk.Factory
  alias Frmwrk.Campaigns

  def fixture(:comment) do
    user = insert(:user)
    campaign = insert(:campaign)
    comment1 = insert(:comment, %{campaign: campaign, user: user, text: "ini komentar pertama"})
    comment2 = insert(:comment, %{campaign: campaign, user: user, text: "ini komentar kedua"})

    {:ok, campaign: campaign, comment1: comment1, comment2: comment2}
  end

  describe "show comments" do
    setup [:create_comment]

    test "show comments", %{conn: conn, campaign: campaign} do
      conn = get conn, campaign_path(conn, :show, campaign.url)

      assert html_response(conn, 200) =~ "ini komentar pertama"
      assert html_response(conn, 200) =~ "ini komentar kedua"
    end
  end

  defp create_comment(_) do
    comment = fixture(:comment)
  end
end
