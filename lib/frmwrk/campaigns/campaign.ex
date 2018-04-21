defmodule Frmwrk.Campaigns.Campaign do
  use Ecto.Schema
  import Ecto.Changeset

  alias Frmwrk.Auth.User

  schema "campaigns" do
    field(:deadline, :date)
    field(:description, :string)
    field(:short_description, :string)
    field(:title, :string)
    field(:image, :string)
    field(:url, :string, null: false)

    belongs_to(:user, User)
    has_many(:comments, Frmwrk.Campaigns.Comment)

    timestamps()
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:title, :short_description, :description, :deadline, :image, :url])
    |> validate_required([:title, :url])
  end
end
