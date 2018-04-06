defmodule Frmwrk.Factory do
  use ExMachina.Ecto, repo: Frmwrk.Repo

  alias Ecto.Date

  def user_factory do
    %Frmwrk.User{
      first_name: "John",
      last_name: "Doe",
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end

  def campaign_factory do
    %Frmwrk.Campaign{
      title: "Pondok IT",
      image_url: "http://via.placeholder.com/350x250",
      description: "Mewujudkan pondok IT yang memajukan umat",
      deadline: Date.cast!("2018-05-20"),
      user: build(:user),
      url: sequence("url")
    }
  end
end
