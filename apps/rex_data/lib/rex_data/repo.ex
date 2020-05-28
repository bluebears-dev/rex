defmodule RexData.Repo do
  use Ecto.Repo,
    otp_app: :rex_data,
    adapter: Ecto.Adapters.Postgres
end
