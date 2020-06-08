defmodule Constants.Events do
  @moduledoc """
  This module provides all event names that are used across the application.
  """
  use Constants

  define(new_project, "NEW:PROJECT")
  define(project_complete, "COMPLETE:PROJECT")
  define(fetch_task, "FETCH:TASK")
  define(no_tasks, "EMPTY:TASK")
end
