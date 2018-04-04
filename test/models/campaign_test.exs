defmodule Frmwrk.CampaignTest do
  use Frmwrk.ModelCase

  alias Frmwrk.Campaign

  @valid_attrs %{deadline: ~D[2010-04-17], description: "some description", image_url: "some image_url", title: "some title"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Campaign.changeset(%Campaign{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Campaign.changeset(%Campaign{}, @invalid_attrs)
    refute changeset.valid?
  end
end
