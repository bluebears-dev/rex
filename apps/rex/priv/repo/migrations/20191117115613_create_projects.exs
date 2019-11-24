defmodule Rex.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :filename, :string
      add :type, ProjectTypeEnum.type(), null: false
      add :width, :integer
      add :height, :integer
      add :starting_frame, :integer
      add :total_frames, :integer
      add :result, :string
      add :state, ProjectStateEnum.type(), null: false

      timestamps()
    end

  end
end
