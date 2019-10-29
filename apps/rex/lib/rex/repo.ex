defmodule Rex.Repo do
  use Ecto.Repo,
    otp_app: :rex,
    adapter: Ecto.Adapters.Postgres
end
