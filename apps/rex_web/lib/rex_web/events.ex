defmodule RexWeb.Events do
  @moduledoc """
  This module provides all event names that are used across the application.
  """
  use Constants

  define new_project, "NEW:PROJECT"
  define fetch_task,  "FETCH:TASK"
end
