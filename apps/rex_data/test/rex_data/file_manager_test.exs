defmodule RexData.FileManagerTest do
  use ExUnit.Case
  import RexData.FileManager

  defmodule CustomFile do
    def mkdir_p(_path) do
      send(self(), :mkdir)
      :ok
    end

    def cp(_path_a, _path_b, _callback) do
      send(self(), :cp)
      :ok
    end
  end

  defmodule BrokenMkdirFile do
    def mkdir_p(_path),
      do: {:error, :always_fails}
  end

  defmodule BrokenCpFile do
    def mkdir_p(_path) do
      send(self(), :mkdir)
      :ok
    end

    def cp(_path_a, _path_b, _callback),
      do: {:error, :always_fails}
  end

  test "copy_file successfully copies the file WHEN there are no errors" do
    assert :ok = copy_file("some_existing_path", "new_filename", CustomFile)

    assert_received :mkdir
    assert_received :cp
  end

  test "copy_file fails WHEN it fails to create path" do
    assert {:error, :always_fails} = copy_file("some_existing_path", "new_filename", BrokenMkdirFile)
  end

  test "copy_file fails WHEN it fails to copy the file" do
    assert {:error, :always_fails} = copy_file("some_existing_path", "new_filename", BrokenCpFile)

    assert_received :mkdir
  end
end
