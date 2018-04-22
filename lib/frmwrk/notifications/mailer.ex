defmodule Frmwrk.Notifications.Mailer do
  use Bamboo.Mailer, otp_app: :frmwrk

  import Bamboo.Email
  alias Frmwrk.Auth.User

  def welcome_email(%User{} = user) do
    new_email()
    |> to(user.email)
    |> from("admin@frmwkr.com")
    |> subject("Selamat bergabung di Frmwrk")
    |> html_body("<strong>Welcome</strong>")
    |> text_body("welcome")
    |> deliver_later()
  end
end
