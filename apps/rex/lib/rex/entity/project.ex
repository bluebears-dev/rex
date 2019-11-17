import EctoEnum
defenum(ProjectTypeEnum, animation: 0, scene: 1)
defenum(ProjectStateEnum, in_progress: 0, complete: 1, canceled: 2)

defmodule Rex.Entity.Project do
  use Ecto.Schema
  import Ecto.Changeset
  @behaviour Access

  schema "projects" do
    field :filename, :string
    field :height, :integer
    field :result, :string, default: nil
    field :starting_frame, :integer
    field :type, ProjectTypeEnum
    field :width, :integer
    field :state, ProjectStateEnum, default: :in_progress

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:filename, :type, :width, :height, :starting_frame, :result, :state])
    |> validate_required([:filename, :type, :width, :height, :starting_frame])
  end

  def fetch(term, key) do
    term
    |> Map.from_struct()
    |> Map.fetch(key)
  end

  def get(term, key, default) do
    term
    |> Map.from_struct()
    |> Map.get(key, default)
  end

  def get_and_update(data, key, function) do
    data
    |> Map.from_struct()
    |> Map.get_and_update(key, function)
  end

  def pop(data, key) do
    data
    |> Map.from_struct()
    |> Map.pop(key)
    end
end
