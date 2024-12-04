# mix run example/simple_01_row.ex

# EXLA.Backend.set_default(:cuda)

defmodule Helper do
  def generate_sequence(n, reverse \\ false) when is_integer(n) and n > 0 do
    1..n-1
    |> Enum.map(fn k ->
      sequence = List.duplicate(0, n - k) ++ List.duplicate(1, k)
      if reverse, do: Enum.reverse(sequence), else: sequence
    end)
  end


  def flatten_one_level(list) do
    Enum.flat_map(list, fn
      sublist when is_list(sublist) -> sublist
      item -> [item]
    end)
  end

  def generate_and_shuffle(times \\ 1, frames \\ 10) when is_integer(times) and times > 0 do
    # Funkce pro generování sekvence
    normal = generate_sequence(frames)
    reversed = generate_sequence(frames, true)

    # Opakujte sekvenci times-krát
    (normal ++ reversed)
    |> List.duplicate(times)  # Duplicitní sekvence podle počtu times
    |> flatten_one_level         # Zploštění seznamu
    |> Enum.shuffle()         # Zamíchání celého seznamu
  end

  def find_change_indices(sequences) when is_list(sequences) do
    sequences
    |> Enum.map(fn sequence ->
      find_first_change(sequence)
    end)
  end

  defp find_first_change(sequence) do
    sequence
    |> Enum.with_index()
    |> Enum.reduce_while(nil, fn {value, index}, _acc ->
      if index > 0 and value != Enum.at(sequence, index - 1) do
        {:halt, index - 1}
      else
        {:cont, nil}
      end
    end)
  end

end

defmodule MyModel do
  def model() do
    Axon.input("x1", shape: {1,10})
    |> Axon.dense(16, activation: :relu)
    |> Axon.dense(8, activation: :relu)
    |> Axon.dense(1)
  end

  def batch do
    input = Helper.generate_and_shuffle(1)
    #|> IO.inspect
    labels = Helper.find_change_indices(input) |> Enum.map(& [&1/10]) |> Enum.to_list
    #|> IO.inspect
    input = Nx.tensor(input)
    y = Nx.tensor(labels)
    { %{"x1" => input}, y}
  end

  defp train_model(model, data, epochs) do
    model
    |> Axon.Loop.trainer(:mean_squared_error, Polaris.Optimizers.adam(learning_rate: 0.01))
    |> Axon.Loop.run(data, %{}, epochs: epochs, iterations: 20)
  end

  def run do
    model = model()
    data = Stream.repeatedly(&batch/0)

    model_state = train_model(model, data, 10)

    Axon.predict(model, model_state, %{"x1" => Nx.tensor([[0, 0, 1, 1, 1, 1, 1, 1, 1, 1]])})
    |> IO.inspect()
  end
end

MyModel.run()
