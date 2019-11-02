defmodule Rex.Repo.Migrations.Group do
  use Ecto.Migration

  def change do
    create table(:group, primary_key: false) do
      add :name, :string, primary_key: true
      timestamps()
    end
  end
end
