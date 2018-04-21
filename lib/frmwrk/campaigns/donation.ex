defmodule Frmwrk.Campaigns.Donation do
  use Ecto.Schema

  alias Frmwrk.Repo
  alias Ecto.Changeset

  import Ecto.Changeset
  import Ecto.Query

  schema "donations" do
    field(:amount, :integer)
    field(:verified_at, :date)
    field(:unique_number, :integer)
    field(:confirmed, :boolean)

    belongs_to(:user, Frmwrk.Auth.User)
    belongs_to(:campaign, Frmwrk.Campaigns.Campaign)

    timestamps()
  end

  # @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:amount, :unique_number])
    |> validate_number(:amount, greater_than_or_equal_to: 20000)
  end

  def add_unique_number(%Changeset{valid?: true} = changeset) do
    unique_number = generate_unique_number()

    changeset
    |> put_change(:amount, get_field(changeset, :amount) + unique_number)
    |> put_change(:unique_number, unique_number)
  end

  def add_unique_number(%Changeset{valid?: false} = changeset), do: changeset

  def generate_unique_number() do
    unique_number = (:rand.uniform() * 1000) |> Kernel.trunc()
    query = from(d in __MODULE__, where: d.amount == ^unique_number and is_nil(d.verified_at))

    case Repo.all(query) do
      [] ->
        unique_number

      _ ->
        generate_unique_number()
    end
  end

  def donation_to_confirm(amount) do
    query = from(d in __MODULE__, where: d.amount == ^amount and is_nil(d.confirmed))

    case Repo.all(query) do
      [campaign | _] ->
        campaign

      _ ->
        nil
    end
  end

  def confirm_donation(%__MODULE__{} = donation, "approve") do
    donation
    |> Ecto.Changeset.change(confirmed: true)
    |> Repo.update()
  end

  def confirm_donation(%__MODULE__{} = donation, "cancel") do
    donation
    |> Repo.delete()
  end
end
