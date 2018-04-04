defmodule Frmwrk.Campaign do
  use Ecto.Schema
  import Ecto.Changeset

  schema "campaigns" do
    field :title, :string
    field :image_url, :string
    field :description, :string
    field :deadline, :date

    belongs_to :user, Frmwrk.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :image_url, :description, :deadline])
    |> validate_required([:title, :image_url, :description, :deadline])
  end
end
