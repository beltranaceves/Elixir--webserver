defmodule Todo.Router do
  use Plug.Router
  require EEx

  alias Todo.Server

  @template "priv/static/template.html.eex"

  plug(Plug.Static, from: :todo, at: "/static")  #Routing de contenido statico (css, js)
  plug(:match)
  plug(:dispatch)
 
  
  get "/" do
    todos = Server.list()
    response = EEx.eval_file(@template, todos: todos)
    send_resp(conn, 200, response)
  end

  get "/service-worker.js" do
    send_file(conn
    |> put_resp_header("Content-Type", "text/javascript"), 200, "service-worker.js")
  end

  post "/" do
    response =
      read_input(conn)
      |> String.replace("+", " ")
      |> Server.add()
      |> build_response

    send_resp(conn, 200, response)
  end

  post "/toggle" do
    response =
      read_input_tuple(conn)
      |> Server.toggle()
      |> build_response

    send_resp(conn, 200, response)
  end

  post "/delete" do
    response =
      read_input(conn)
      |> Server.remove()
      |> build_response

    send_resp(conn, 200, response)
  end

  match(_, do: send_resp(conn, 404, "This is not the page you are looking for"))

  defp read_input(conn) do
    {:ok, body, _conn} = read_body(conn)
    "item=" <> item = body
    item
  end

  defp read_input_tuple(conn) do
    {:ok, body, _conn} = read_body(conn)
    split_body = String.split(body, "&")
    "item=" <> item = Enum.at(split_body, 0)
    "name=" <> name = Enum.at(split_body, 1) 
                      |> String.replace("+", " ")
    "done=" <> done = Enum.at(split_body, 2)
    %{id: item, name: name, done: done}
  end

  defp build_response(todos) do
    EEx.eval_file(@template, todos: todos)
  end
end
