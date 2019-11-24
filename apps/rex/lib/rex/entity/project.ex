import EctoEnum
defenum(ProjectTypeEnum, animation: 0, scene: 1)
defenum(ProjectStateEnum, queued: -1, in_progress: 0, complete: 1, canceled: 2)

defmodule Rex.Entity.Project do
  use Ecto.Schema
  import Ecto.Changeset
  @behaviour Access

  @derive {
    Jason.Encoder,
    only: [:id, :path, :height, :width, :state, :result, :starting_frame, :total_frames, :type]
  }
  schema "projects" do
    field :path, :string
    field :height, :integer
    field :result, :string, default: nil
    field :starting_frame, :integer
    field :total_frames, :integer
    field :type, ProjectTypeEnum
    field :width, :integer
    field :state, ProjectStateEnum, default: :queued

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:path, :type, :width, :height, :starting_frame, :total_frames, :result, :state])
    |> validate_required([:path, :type, :width, :height, :starting_frame, :total_frames])
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
