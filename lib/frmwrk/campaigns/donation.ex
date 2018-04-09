defmodule Frmwrk.Campaigns.Donation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "donations" do
    field :amount, :integer
    field :verified_at, :date
    field :donatur_id, :id

    timestamps()
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:amount, :verified_at])
    |> validate_required([:amount, :verified_at])
  end
end
