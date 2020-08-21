defmodule RexData.FilenameGenerator.StubFilename do
  @behaviour RexData.FilenameGenerator

  @impl RexData.FilenameGenerator
  def generate_filename(_postfix),
    do: "stub_filename"
end
