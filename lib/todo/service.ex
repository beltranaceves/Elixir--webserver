defmodule Todo.Service do
    #Service
    
    def add_todo(state, todo) do
      new_todo = %{name: todo, done: false, id: generate_id()}
      _new_state = state ++ [new_todo]
    end

    def toggle_todo(state, id) do
      [todo] = Enum.filter(state, fn x -> x.id == id end)
      toggled_todo = %{todo | done: !todo.done}

      _new_state =
        state
        |> Enum.map(fn x ->
          if is_id?(x, id) do
            toggled_todo
          else
            x
          end
        end)
    end

    def delete_todo(state, id) do
      _new_state =
      state
      |> Enum.filter(fn x ->
        !is_id?(x, id)
      end)
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
  