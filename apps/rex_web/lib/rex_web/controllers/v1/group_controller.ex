require Logger

defmodule RexWeb.V1.GroupController do
  use RexWeb, :controller

  alias Jason
  alias Rex.Nodes

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"name" => id}) do
    case Nodes.create_group(%{name: id}) do
      {:ok, _new_group} ->
        Logger.debug("Group creation successful")

        conn
        |> send_resp(:created, "")

      {:error, %{errors: trace}} ->
        Logger.error("Group creation has failed: #{inspect(trace)}")

        conn
        |> put_status(:bad_request)
        |> json(format_validation_errors(trace))
    end
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{"name" => name}) do
    group = Nodes.get_group!(name)
    {:ok, _node} = Nodes.delete_group(group)

    conn
    |> send_resp(:no_content, "")
  end

  defp format_validation_errors(error_keyword_list) do
    error_map =
      Enum.into(
        error_keyword_list,
        [],
        fn {key, tuple} ->
          to_string(key) <> " " <> elem(tuple, 0)
        end
      )

    %{:cause => error_map}
  end
end
