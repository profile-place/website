defmodule ProfilePlaceWeb.Router do
  use ProfilePlaceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api_endpoint do
    plug :accepts, ["json"]
  end

  pipeline :require_cookie_auth do
    plug ProfilePlaceWeb.Plugs.AuthenticateCookie
  end

  pipeline :require_header_auth do
    plug ProfilePlaceWeb.Plugs.AuthenticateHeader
  end

  pipeline :require_some_auth do
    plug ProfilePlaceWeb.Plugs.AuthenticateSome
  end

  scope "/", ProfilePlaceWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/login", PageController, :login
    get "/join", PageController, :join
    get "/profile", PageController, :profile
    get "/slugmanagementpage", PageController, :slugmanagementpage
    get "/@:id", ProfileController, :show
  end

  scope "/api", ProfilePlaceWeb do
    scope "/account" do
      pipe_through :api_endpoint

      post "/signup", AccountController, :signup
      post "/login", AccountController, :login
    end

    scope "/slug" do
      pipe_through [:api_endpoint, :require_some_auth]

      get "/add", SlugController, :add
    end
  end

  scope "/oauth", ProfilePlaceWeb do
    pipe_through [:browser, :require_cookie_auth]

    get "/discord", DiscordController, :init
    get "/discord-cb", DiscordController, :callback

    get "/spotify", SpotifyController, :init
    get "/spotify-cb", SpotifyController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProfilePlaceWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ProfilePlaceWeb.Telemetry
    end
  end
end
