import EctoEnum
defenum(ProjectTypeEnum, animation: 0, scene: 1)
defenum(ProjectStateEnum, queued: -1, in_progress: 0, complete: 1, canceled: 2)

defmodule RexData.Project.ProjectInfo do
  use Ecto.Schema
  import Ecto.Changeset
  alias RexData.Project.ProjectInfo

  @required_fields [:path, :type, :width, :height, :starting_frame, :total_frames]

  @derive {
    Jason.Encoder,
    only: [:id, :state, :result | @required_fields]
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

  @spec new(map) :: Ecto.Changeset.t()
  def new(attrs) do
    %ProjectInfo{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end

  @spec changeset(%ProjectInfo{}, map) :: Ecto.Changeset.t()
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:result, :state | @required_fields])
    |> validate_required(@required_fields)
  end
end
