defmodule RexData.Application do
  alias RexData.{Repo, Manager}
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Repo,
      {Manager, %Manager{project: nil}}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: RexData.Supervisor)
  end
end
