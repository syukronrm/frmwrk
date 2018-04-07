defmodule Frmwrk.Campaign do
  use Ecto.Schema
  import Ecto.Changeset

  schema "campaigns" do
    field :title, :string
    field :image_url, :string
    field :description, :string
    field :deadline, :date
    field :url, :string

    belongs_to :user, Frmwrk.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :image_url, :description, :deadline, :url])
    |> validate_required([:title, :description, :url])
    |> unique_constraint(:url)
  end
end
