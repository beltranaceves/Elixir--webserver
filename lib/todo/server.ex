defmodule Todo.Server do
  use GenServer

  # Client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def list() do
    GenServer.call(__MODULE__, {:list})
  end

  def add(todo) do
    GenServer.call(__MODULE__, {:add, todo})
  end

  def remove(id) do
    GenServer.call(__MODULE__, {:delete, id})
  end

  def toggle(id) do
    GenServer.call(__MODULE__, {:toggle, id})
  end

  # Server

  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:list}, _from, state) when state !=nil do
    {:reply, state, state}
  end

  def handle_call({:add, todo}, _from, state) do
    new_todo = %{name: todo, done: false, id: generate_id()}
    new_state = state ++ [new_todo]
    {:reply, new_state, new_state}
  end

  def handle_call({:toggle, tuple}, _from, state) when tuple.id != nil do
    case Enum.filter(state, fn x -> x.id == tuple.id end) do
      [todo] -> toggled_todo = %{todo | done: !todo.done}
                IO.inspect(todo.done)
                new_state =
                  state
                  |> Enum.map(fn x ->
                    if is_id?(x, tuple.id) do
                      toggled_todo
                    else
                      x
                    end
                  end)

                {:reply, new_state, new_state}
      [] -> IO.puts("No encontrado")
            new_todo = %{name: tuple.name, done: tuple.done, id: generate_id()}
            new_state = state ++ [new_todo]
            {:reply, new_state, new_state}
    end
    
  end

  def handle_call({:delete, id}, _from, state) do
    new_state =
      state
      |> Enum.filter(fn x ->
        !is_id?(x, id)
      end)

    {:reply, new_state, new_state}
  end

  defp is_id?(x, id), do: x.id == id

  defp generate_id() do
    # This generates a basic ID for us, ends up being something
    # like "CeiGYfspjHJAld42hI3OY1lbulxGkyR8W-zqXpkSMwpilPFtv0uE5jCW229-k47J"
    # which will not completely prevent collisions, but will reduce
    # their chances.
    :crypto.strong_rand_bytes(64)
    |> Base.url_encode64()
    |> binary_part(0, 64)
  end
end
