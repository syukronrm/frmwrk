defmodule FrmwrkWeb.CommentControllerText do
  use FrmwrkWeb.ConnCase

  import Frmwrk.Factory
  alias Frmwrk.Campaigns

  @valid_attrs %{text: "tes komentar"}
  @invalid_attrs %{text: ""}

  def fixture(:comment) do
    user = insert(:user)
    campaign = insert(:campaign)
    comment1 = insert(:comment, %{campaign: campaign, user: user, text: "ini komentar pertama"})
    comment2 = insert(:comment, %{campaign: campaign, user: user, text: "ini komentar kedua"})

    {:ok, campaign: campaign, comment1: comment1, comment2: comment2}
  end

  def fixture(:campaign) do
    user = insert(:user)
    campaign = insert(:campaign)

    {:ok, user: user, campaign: campaign}
  end

  describe "show comments" do
    setup [:create_comment]

    @tag comment: true
    test "show comments", %{conn: conn, campaign: campaign} do
      conn = get conn, campaign_path(conn, :show, campaign.url)

      assert html_response(conn, 200) =~ "ini komentar pertama"
      assert html_response(conn, 200) =~ "ini komentar kedua"
    end
  end

  describe "form validation" do
    setup [:create_campaign]

    @tag comment: true
    test "show create new comment form when user is campaign's backer or campaigner", %{conn: conn, campaign: campaign, user: user} do
      conn =
        conn
        |> assign(:user, user)
        |> post(campaign_path(conn, :show, campaign.url), @valid_attrs)

      assert html_response(conn, 200) =~ "<button type=\"submit\""
    end

    @tag comment: true
    test "do not show new comment form when user is not logged in", %{conn: conn, campaign: campaign} do
      conn = get conn, campaign_path(conn, :show, campaign.url)

      assert html_response(conn, 200) =~ "Anda harus login terlebih dahulu"
    end
  end

  describe "new" do
    setup [:create_campaign]

    @tag comment: true
    test "show info flash when comment is valid", %{conn: conn, user: user, campaign: campaign} do
      conn =
        conn
        |> assign(:user, user)
        |> post(campaign_path(conn, :campaign_new), @valid_attrs)

      assert redirected_to(conn) == campaign_path(conn, :show, campaign.url)
      assert get_flash(conn, :info) =~ "Terima kasih atas komentar Anda"
    end

    @tag comment: true
    test "show error flash when comment is invalid", %{conn: conn, user: user, campaign: campaign} do
      conn =
        conn
        |> assign(:user, user)
        |> post(campaign_path(conn, :campaign_new), @invalid_attrs)

      assert redirected_to(conn) == campaign_path(conn, :show, campaign.url)
      assert get_flash(conn, :error) =~ "Harap isi kolom komentar"
    end
  end

  defp create_comment(_) do
    comment = fixture(:comment)
  end

  defp create_campaign(_) do
    campaign = fixture(:campaign)
  end
end
