defmodule RexWeb.Router do
  use RexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RexWeb do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/projects", ProjectController, only: [:create, :delete], param: "id"
      get "/projects/:id/file", ProjectController, :download
    end
  end
end
