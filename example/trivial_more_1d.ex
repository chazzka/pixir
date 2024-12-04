defmodule Model do

  def model() do
    Axon.input("x1")
    #|> Axon.conv(4, kernel_size: {2})
    |> Axon.dense(4) #neni potreba skryta, jednoduchy ukol
    |> Axon.flatten
    |> Axon.dense(1)
  end

  def batch() do
    input = [[1], [2], [2], [1]]
    out = [[1], [0],[0], [1]] # sude, liche, sude, liche
    # Vytvoření tensorů
    input = Nx.tensor(input, names: [:batch, :features])
    labels = Nx.tensor(out, names: [:batch, :features])

    { %{"x1" => input}, labels }
  end

  defp train_model(model, data, epochs) do
    model
    |> Axon.Loop.trainer(:mean_squared_error, Polaris.Optimizers.adam(learning_rate: 0.01))
    |> Axon.Loop.run(data, %{}, epochs: epochs, iterations: 20)
  end

  # Funkce pro spuštění modelu
  def run() do
    model = model()
    data = Stream.repeatedly(fn -> batch() end)

    model_state = train_model(model, data, 10)

    # Testovací predikce
    Axon.predict(model, model_state, %{"x1" => Nx.tensor([[1]])})
    |> IO.inspect()
  end
end

Model.run()
