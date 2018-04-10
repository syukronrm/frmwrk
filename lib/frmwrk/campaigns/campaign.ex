defmodule Frmwrk.Campaigns.Campaign do
  use Ecto.Schema
  import Ecto.Changeset

  alias Frmwrk.Auth.User

  schema "campaigns" do
    field :deadline, :date
    field :description, :string
    field :short_description, :string
    field :title, :string
    field :image, :string
    field :url, :string
    field :campainger_id, :id

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:title, :short_description, :description, :deadline])
    |> validate_required([:title, :short_description, :description, :deadline])
  end
end
