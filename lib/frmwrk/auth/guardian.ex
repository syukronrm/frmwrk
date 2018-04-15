defmodule Frmwrk.Auth.Guardian do
  use Guardian, otp_app: :frmwrk

  alias Frmwrk.Auth
  alias Frmwrk.Auth.User

  def subject_for_token(%User{} = user, _claims), do: {:ok, user.id}
  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => id}), do: {:ok, Auth.get_user!(id)}
  def resource_from_claims(_), do: {:error, "Unknown resource type"}
end
