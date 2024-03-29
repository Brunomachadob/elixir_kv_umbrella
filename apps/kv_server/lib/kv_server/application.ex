defmodule KVServer.Application do
  use Application

  def start(_type, _args) do
    port = Application.fetch_env!(:kv_server, :port) |> String.to_integer()

    children = [
      {Task.Supervisor, name: KVServer.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> KVServer.accept(port) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: KVServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
