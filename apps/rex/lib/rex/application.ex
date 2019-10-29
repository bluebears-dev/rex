defmodule Rex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Rex.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Rex.Supervisor)
  end
end
