defmodule RexData.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias RexData.{Repo, State}

  def start(_type, _args) do
    children = [
      Repo,
      {State, %State{project: nil}}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: RexData.Supervisor)
  end
end
