defmodule FrmwrkWeb.Router do
  use FrmwrkWeb, :router

  pipeline :auth do
    plug Frmwrk.Auth.Pipeline
    plug Frmwrk.Plugs.SetUser
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FrmwrkWeb do
    pipe_through [:browser, :auth] # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    # resources "/campaigns", CampaignController
  end

  scope "/campaigns", FrmwrkWeb do
    pipe_through [:browser, :auth]

    get "/", CampaignController, :index
    get "/new", CampaignController, :new
    post "/create", CampaignController, :create
    get "/:url", CampaignController, :show

    get "/:url/comment", CampaignController, :comment_new

    get "/:url/donation", DonationController, :new
    post "/:url/donation", DonationController, :create
    post "/:url/donation/:amount/:action", DonationController, :confirm
  end

  scope "/auth", FrmwrkWeb do
    pipe_through [:browser, :auth]

    get "/login", AuthController, :login
    post "/login", AuthController, :create_login

    get "/password", AuthController, :password
    post "/password", AuthController, :set_password

    get "/signout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback

  end

  # Other scopes may use custom stacks.
  # scope "/api", FrmwrkWeb do
  #   pipe_through :api
  # end
end
