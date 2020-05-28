defmodule RexData.Repo.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes, primary_key: false) do
      add :node_id, :uuid, primary_key: true
      add :name, :string, null: false

      # inserted_at and updated_at
      timestamps()
    end
  end
end
