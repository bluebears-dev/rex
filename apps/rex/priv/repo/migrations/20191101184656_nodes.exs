defmodule Rex.Repo.Migrations.Node do
  use Ecto.Migration

  def change do
    create table(:node, primary_key: false) do
      add :node_id, :uuid, primary_key: true
      add :name, :string, null: false
      add :rendering_client, RenderingClientEnum.type(), null: false
      add :performance, :integer, default: -1

      add :group,
          references(
            :group,
            type: :string,
            column: :name,
            on_delete: :delete_all
          )

      # inserted_at and updated_at
      timestamps()
    end
  end
end
