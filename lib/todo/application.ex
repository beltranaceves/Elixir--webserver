defmodule Todo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    var_port = get_port()
    children = [
      {Plug.Cowboy, scheme: :http, plug: Todo.Router, options: [port: var_port]},
      {Todo.Server, [name: Todo.Server]}
    ]

    Logger.info("Starting application on port #{var_port}.")
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Todo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_port() do
    port_env_variable = System.get_env("PORT")
    if is_nil(port_env_variable) do
      3000
    else
      String.to_integer(port_env_variable)
    end
  end
end
