defmodule RexData.FileManagerTest do
  use ExUnit.Case
  import RexData.FileManager
  alias RexData.FileManager.{BrokenCpFile, BrokenMkdirFile, CustomFile}

  test "copy_file successfully copies the file WHEN there are no errors" do
    assert :ok = copy_file("some_existing_path", "new_filename", CustomFile)

    assert_received :mkdir
    assert_received {:cp, "some_existing_path", "test/path/new_filename", do_overwrite?}
    refute do_overwrite?
  end

  test "copy_file fails WHEN it fails to create path" do
    assert {:error, :always_fails} = copy_file("some_existing_path", "new_filename", BrokenMkdirFile)
  end

  test "copy_file fails WHEN it fails to copy the file" do
    assert {:error, :always_fails} = copy_file("some_existing_path", "new_filename", BrokenCpFile)

    assert_received :mkdir
  end
end
