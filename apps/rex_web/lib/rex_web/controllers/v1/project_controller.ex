require Logger

defmodule RexWeb.V1.ProjectController do
  use RexWeb, :controller

  alias Jason
  alias Rex.Entity

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, body) do
    case Entity.create_project(body) do
      {:ok, new_project} ->
        conn
        |> send_resp(:ok, Jason.encode!(%{id: new_project[:id]}))
      {:error, message} when is_binary(message) ->
        conn
        |> send_resp(:bad_request, Jason.encode!([message]))
      {:error, changeset} ->
        conn
        |> send_resp(:bad_request, Jason.encode!(Entity.format_validation_errors(changeset.errors)))
    end
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    case Entity.cancel_project(id) do
      {:ok, _changeset} ->
        conn
        |> send_resp(:no_content, "")
      {:error, message} when is_binary(message) ->
        conn
        |> send_resp(:not_found, Jason.encode!([message]))
      {:error, changeset} ->
        conn
        |> send_resp(:bad_request, Jason.encode!(Entity.format_validation_errors(changeset.errors)))
    end
  end
end
