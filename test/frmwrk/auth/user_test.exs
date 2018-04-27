defmodule Frmwrk.Auth.UserTest do
  use Frmwrk.DataCase, async: true

  import Frmwrk.Factory

  alias Frmwrk.Auth.User

  describe "User.registration_changeset/2" do
    @valid_attrs %{
      name: "Test Name",
      email: "testname@gmail.com",
      password: "sandi",
      password_confirmation: "sandi"
    }
    @invalid_attrs %{}

    @tag valid_user: "true"
    test "changeset with valid attrs" do
      changeset = User.registration_changeset %User{}, @valid_attrs

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = User.registration_changeset %User{}, @invalid_attrs

      refute changeset.valid?
    end

    test "changeset with invalid password" do
      changeset = User.registration_changeset %User{}, %{@valid_attrs | password: "test"}

      refute changeset.valid?
    end
    
    @tag user_invalid_name: "true"
    test "changeset with invalid name" do
      changeset = User.registration_changeset %User{}, %{@valid_attrs | name: ""}

      refute changeset.valid?
    end

    @tag user_pass_hashed: "true"
    test "password hashed" do
      changeset = User.registration_changeset %User{}, @valid_attrs

      assert Comeonin.Bcrypt.checkpw("sandi", changeset.changes.password_hash)
    end

    test "email must be converted to lowercase" do
      changeset = User.registration_changeset %User{}, %{@valid_attrs | email: "TEST@mail.com"}

      assert changeset.changes.email == "test@mail.com"
    end
  end

  describe "User.check_user/1" do
    @valid_attrs %{
      email: "test@gmail.com",
      password: "sandi"
    }

    @tag check_creds: "true"
    test "check valid user" do
      insert(:user, @valid_attrs)

      {result, _reason} = User.check_creds_ @valid_attrs

      assert result == :ok
    end
    
    @tag check_creds: "true"
    test "check invalid password" do
      insert(:user, @valid_attrs)

      {result, _reason} = User.check_creds_(%{ @valid_attrs | password: "test"})

      assert result == :error
    end

    @tag check_creds: "true"
    test "check invalid input" do
      insert(:user, @valid_attrs)

      {result, _reason} = User.check_creds_(%{})

      assert result == :error
    end
  end

  def create_user(_) do
    insert(:user)
  end
end
