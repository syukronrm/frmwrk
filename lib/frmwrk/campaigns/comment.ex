defmodule Frmwrk.Campaigns.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :text, :string

    belongs_to :campaign, Frmwrk.Campaigns.Campaign
    belongs_to :user, Frmwrk.Auth.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
