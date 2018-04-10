defmodule FrmwrkWeb.Router do
  use FrmwrkWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Frmwrk.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FrmwrkWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    # resources "/campaigns", CampaignController
  end

  scope "/campaigns", FrmwrkWeb do
    pipe_through :browser

    get "/", CampaignController, :index
    get "/new", CampaignController, :new
    post "/create", CampaignController, :create
    get "/:url", CampaignController, :show
  end

  scope "/auth", FrmwrkWeb do
    pipe_through :browser

    get "/signout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrmwrkWeb do
  #   pipe_through :api
  # end
end
