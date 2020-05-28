defmodule RexData.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :frame, :integer
      add :path, :string

      add :project,
          references(:projects,
            on_delete: :delete_all
          )

      add :node,
          references(:nodes,
            on_delete: :nilify_all,
            column: :node_id,
            type: :uuid
          )

      timestamps()
    end

    create index(:tasks, [:project])
    create index(:tasks, [:node])
  end
end
