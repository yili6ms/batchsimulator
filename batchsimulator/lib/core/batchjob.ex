defmodule Core.Batchjob do
  use GenServer

  def init(args \\ %{}) do
    {:ok, args}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def request_run() do
    to_string(:erlang.ref_to_list(:erlang.make_ref()))
  end

  def add_task(executionid, task, payload) do
    GenServer.cast(__MODULE__, {:add_task, executionid, task, payload})
  end

  def add_task_list(executionid, task_list) do
    Enum.each(task_list, fn {task, payload} -> add_task(executionid, task, payload) end)
  end

  def start_job(execution_id) do
    GenServer.cast(__MODULE__, {:start_job, execution_id})
  end

  def trigger_run() do
    GenServer.call(__MODULE__, :trigger_run)
  end

  def handle_call(:trigger_run, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:add_task, executionid, task, payload}, state) do
    {:noreply, Map.update(state, executionid, [{task, payload}], fn tasks -> tasks ++ [{task, payload}] end)}
  end
end
