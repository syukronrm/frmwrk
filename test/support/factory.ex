defmodule Frmwrk.Factory do
  use ExMachina.Ecto, repo: Frmwrk.Repo

  alias Frmwrk.Campaigns.Campaign
  alias Frmwrk.Campaigns.Comment
  alias Frmwrk.Auth.User
  alias Ecto.Date

  def user_factory do
    %User{
      name: "Joe Dahl",
      email: sequence(:email, &"email-#{&1}@example.com"),
      role: 3,
      password_hash: Bcrypt.hash_pwd_salt("sandi")
    }
  end

  def campaign_factory do
    %Campaign{
      title: sequence(:title, &"Campaign #{&1}"),
      image: "http://via.placeholder.com/350x250",
      short_description: "Deskripsi Pendek",
      description: "Deskripsi panjang lorem ipsum",
      deadline: Date.cast!("2018-05-20"),
      user: build(:user),
      url: sequence("url")
    }
  end

  def comment_factory do
    %Comment{
      text: sequence(:text, &"Comment #{&1}"),
      user: build(:user),
      campaign: build(:campaign)
    }
  end
end
