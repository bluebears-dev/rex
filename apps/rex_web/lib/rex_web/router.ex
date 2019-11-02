defmodule RexWeb.Router do
  use RexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RexWeb do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/groups", GroupController, only: [:create, :delete], param: "name"
    end
  end
end
