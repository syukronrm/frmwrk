defmodule Frmwrk.Factory do
  use ExMachina.Ecto, repo: Frmwrk.Repo

  alias Frmwrk.Campaigns.Campaign
  alias Frmwrk.Auth.User
  alias Ecto.Date

  def user_factory do
    %User{
      name: "Joe Dahl",
      email: sequence(:email, &"email-#{&1}@example.com"),
      role: 3
    }
  end

  def campaign_factory do
    %Campaign{
      title: "Pondok IT",
      image: "http://via.placeholder.com/350x250",
      short_description: "Mewujudkan pondok IT",
      description: "Mewujudkan pondok IT yang memajukan umat",
      deadline: Date.cast!("2018-05-20"),
      user: build(:user),
      url: sequence("url")
    }
  end
end
