defmodule RexData.FilenameGenerator.UniqueTest do
  use ExUnit.Case
  import RexData.FilenameGenerator.Unique
  alias RexData.FilenameGenerator.Unique

  test "generate_filename returns unique name" do
    postfix = ".blend"
    filename_one = generate_filename(postfix)
    filename_second = generate_filename(postfix)

    assert filename_one =~ postfix
    refute filename_one == filename_second
  end
end
