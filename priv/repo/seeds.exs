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

alias Frmwrk.User
alias Frmwrk.Campaign

# SUPER_ADMIN = 1
# ADMIN = 2
# CAMPAIGNER = 3
# DONATUR = 4

Repo.delete_all(User)
Repo.delete_all(Campaign)

{:ok, _} = Repo.insert %User{
  first_name: "Campaigner",
  last_name: "User",
  email: "usercampaigner@gmail.com",
  role: User.type(:CAMPAIGNER)
}

{:ok, _} = Repo.insert %User{
  first_name: "John",
  last_name: "Doe",
  email: "johndoe@gmail.com",
  role: User.type(:DONATUR)
}

{:ok, _} = Repo.insert %Campaign{
  title: "Campaign One",
  short_description: "Dolore velit dolor exercitationem ut cupiditate",
  description: "Dolore velit dolor exercitationem ut cupiditate. Quisquam eum animi numquam modi. Explicabo occaecati qui qui ea officiis. Eos eius sint enim. Laudantium dicta exercitationem ea ex. Odit est at dignissimos. Odit quas consequatur eos quos. Et eum dolorem nemo quis quo.",
  image_url: "asdasdsa",
  url: "campaignone",
  deadline: Date.cast!("2018-07-20")
}

{:ok, _} = Repo.insert %Campaign{
  title: "Campaign Two",
  short_description: "Dolore velit dolor exercitationem ut cupiditate",
  description: "Dolore velit dolor exercitationem ut cupiditate. Quisquam eum animi numquam modi. Explicabo occaecati qui qui ea officiis. Eos eius sint enim. Laudantium dicta exercitationem ea ex. Odit est at dignissimos. Odit quas consequatur eos quos. Et eum dolorem nemo quis quo.",
  image_url: "asibdnjas",
  url: "campaigntwo",
  deadline: Date.cast!("2018-06-10")
}

{:ok, _} = Repo.insert %Campaign{
  title: "Campaign Three",
  short_description: "Dolore velit dolor exercitationem ut cupiditate",
  description: "Dolore velit dolor exercitationem ut cupiditate. Quisquam eum animi numquam modi. Explicabo occaecati qui qui ea officiis. Eos eius sint enim. Laudantium dicta exercitationem ea ex. Odit est at dignissimos. Odit quas consequatur eos quos. Et eum dolorem nemo quis quo.",
  image_url: "askdbas",
  url: "campaignthree",
  deadline: Date.cast!("2018-05-10")
}
