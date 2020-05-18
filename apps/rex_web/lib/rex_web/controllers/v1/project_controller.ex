require Logger

defmodule RexWeb.V1.ProjectController do
  use RexWeb, :controller

  alias Jason
  alias Rex.Utils
  alias RexWeb.{ProjectHandler, TaskHandler}

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, body) do
    status = ProjectHandler.handle_new(body)
    Logger.debug("Project handler response #{inspect status}")
    case status do
      {:ok, response} ->
        conn
        |> send_resp(:ok, Jason.encode!(response))
      {:warn, message} ->
        conn
        |> send_resp(:accepted, Jason.encode!([message]))
      {:error, message, status} when is_binary(message) ->
        conn
        |> send_resp(status, Jason.encode!([message]))
      {:error, changeset} ->
        conn
        |> send_resp(:bad_request, Jason.encode!(Utils.format_validation_errors(changeset.errors)))
    end
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    case ProjectHandler.handle_project_status(id) do
      {:ok, response} ->
        conn
        |> send_resp(:ok, Jason.encode!(response))
      {:error, message, status} when is_binary(message) ->
        conn
        |> send_resp(status, message)
      {:error, changeset} ->
        conn
        |> send_resp(:bad_request, Jason.encode!(Utils.format_validation_errors(changeset.errors)))
    end
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    case ProjectHandler.handle_cancel(id) do
      {:ok, _changeset} ->
        conn
        |> send_resp(:no_content, "")
      {:error, message, status} when is_binary(message) ->
        conn
        |> send_resp(status, Jason.encode!([message]))
      {:error, changeset} ->
        conn
        |> send_resp(:bad_request, Jason.encode!(Utils.format_validation_errors(changeset.errors)))
    end
  end

  def download(conn, %{"id" => id}) do
    case ProjectHandler.handle_download(id) do
      {:ok, path} ->
        conn
        |> put_resp_header("content-disposition", ~s(attachment; filename="#{path}"))
        |> send_file(200, path)
      {:error, message, status} ->
        conn
        |> send_resp(status, Jason.encode!([message]))
    end
  end

  def register_fragment(conn, %{"id" => id, "frame" => frame, "fragment" => file}) do
    TaskHandler.save_fragment(id, frame, file)
    conn
    |> send_resp(200, "")
  end
end
