defmodule Frmwrk.Campaigns do
  @moduledoc """
  The Campaigns context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Frmwrk.Repo

  alias Frmwrk.Campaigns.Campaign
  alias Frmwrk.Auth.User

  def list_campaigns do
    Repo.all(Campaign)
  end

  def get_campaign!(id), do: Repo.get! Campaign, id

  def get_campaign_by_url(url), do: Repo.get_by Campaign, url: url

  def create_campaign(attrs \\ %{}) do
    %Campaign{}
    |> Campaign.changeset(attrs)
    |> Repo.insert()
  end

  def update_campaign(%Campaign{} = campaign, attrs) do
    campaign
    |> Campaign.changeset(attrs)
    |> Repo.update()
  end

  def delete_campaign(%Campaign{} = campaign) do
    Repo.delete(campaign)
  end

  def change_campaign(%Campaign{} = campaign) do
    Campaign.changeset(campaign, %{})
  end

  alias Frmwrk.Campaigns.Donation

  def list_donations do
    Repo.all(Donation)
  end

  def get_donation!(id), do: Repo.get!(Donation, id)

  def create_donation(attrs \\ %{}, %Campaign{} = campaign, %User{} = user) do
    %Donation{}
    |> Donation.changeset(attrs)
    |> put_assoc(:user, user)
    |> put_assoc(:campaign, campaign)
    |> Donation.add_unique_number()
    |> Repo.insert()
  end

  def update_donation(%Donation{} = donation, attrs) do
    donation
    |> Donation.changeset(attrs)
    |> Repo.update()
  end

  def delete_donation(%Donation{} = donation) do
    Repo.delete(donation)
  end

  def change_donation(%Donation{} = donation) do
    Donation.changeset(donation, %{})
  end

  alias Frmwrk.Campaigns.Comment

  def list_comments do
    Repo.all(Comment)
  end

  def get_comment!(id), do: Repo.get!(Comment, id)

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
