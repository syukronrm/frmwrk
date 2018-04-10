# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Frmwrk.Repo.insert!(%Frmwrk.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Ecto.Date

alias Frmwrk.Repo

alias Frmwrk.Auth.User
alias Frmwrk.Campaigns.Campaign

Repo.delete_all(User)
Repo.delete_all(Campaign)

# Campaigner
{:ok, campaigner1} = Repo.insert %User{
  name: "Campaigner One",
  email: "usercampaigner1@gmail.com",
  role: User.type(:campaigner)
}

Repo.insert %User{
  name: "Campaigner Two",
  email: "usercampaigner2@gmail.com",
  role: User.type(:campaigner)
}

Repo.insert %User{
  name: "Campaigner Three",
  email: "usercampaigner3@gmail.com",
  role: User.type(:campaigner)
}

# Donatur
Repo.insert %User{
  name: "Donatur One",
  email: "donatur1@gmail.com",
  role: User.type(:donatur)
}

# Campaign
{:ok, _} = Repo.insert %Campaign{
  title: "Campaign One",
  short_description: "Dolore velit dolor exercitationem ut cupiditate",
  description: "Dolore velit dolor exercitationem ut cupiditate. Quisquam eum animi numquam modi. Explicabo occaecati qui qui ea officiis. Eos eius sint enim. Laudantium dicta exercitationem ea ex. Odit est at dignissimos. Odit quas consequatur eos quos. Et eum dolorem nemo quis quo.",
  image: "asdasdsa",
  url: "campaignone",
  user_id: campaigner1.id,
  deadline: Date.cast!("2018-07-20")
}

{:ok, _} = Repo.insert %Campaign{
  title: "Campaign Two",
  short_description: "Dolore velit dolor exercitationem ut cupiditate",
  description: "Dolore velit dolor exercitationem ut cupiditate. Quisquam eum animi numquam modi. Explicabo occaecati qui qui ea officiis. Eos eius sint enim. Laudantium dicta exercitationem ea ex. Odit est at dignissimos. Odit quas consequatur eos quos. Et eum dolorem nemo quis quo.",
  image: "asibdnjas",
  url: "campaigntwo",
  user_id: campaigner1.id,
  deadline: Date.cast!("2018-06-10")
}

{:ok, _} = Repo.insert %Campaign{
  title: "Campaign Three",
  short_description: "Dolore velit dolor exercitationem ut cupiditate",
  description: "Dolore velit dolor exercitationem ut cupiditate. Quisquam eum animi numquam modi. Explicabo occaecati qui qui ea officiis. Eos eius sint enim. Laudantium dicta exercitationem ea ex. Odit est at dignissimos. Odit quas consequatur eos quos. Et eum dolorem nemo quis quo.",
  image: "askdbas",
  url: "campaignthree",
  user_id: campaigner1.id,
  deadline: Date.cast!("2018-05-10")
}
