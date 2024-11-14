defmodule Hive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Hive.Worker.start_link(arg)
      # {Hive.Worker, arg}
      {Cluster.Supervisor, [topologies(), [name: SimpleCluster.ClusterSupervisor]]},
      Hive.Observer,
      Hive.Ping
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp topologies do
    [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [
          hosts: [
            :"n1@127.0.0.1",
            :"n2@127.0.0.1"
          ]
        ]
      ]
    ]
  end
end
