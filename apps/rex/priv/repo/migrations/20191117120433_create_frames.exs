defmodule Rex.Repo.Migrations.CreateFrames do
  use Ecto.Migration

  def change do
    create table(:frames) do
      add :number, :integer
      add :complexity, :float
      add :resultPath, :string
      add :project, references(:projects, on_delete: :nothing)

      timestamps()
    end

    create index(:frames, [:project])
  end
end
