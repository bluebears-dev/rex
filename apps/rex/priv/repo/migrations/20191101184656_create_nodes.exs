defmodule Rex.Repo.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes, primary_key: false) do
      add :node_id, :uuid, primary_key: true
      add :name, :string, null: false
      add :performance, :integer, default: -1

      # inserted_at and updated_at
      timestamps()
    end
  end
end
