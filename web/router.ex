defmodule Graphql.Router do
  use Graphql.Web, :router

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

  pipeline :graphql do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Graphql.Web.Context
  end

  scope "/", Graphql do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api" do
    pipe_through :graphql

    forward "/", Absinthe.Plug,
    schema: Graphql.Schema
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: Graphql.Schema

  # Other scopes may use custom stacks.
  # scope "/api", Graphql do
  #   pipe_through :api
  # end
end
