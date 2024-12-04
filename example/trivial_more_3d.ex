defmodule Model do
  def batch() do
    input = [
      [[1,1],[1,1]],
      [[2,2],[2,2]],
      [[2,2],[2,2]],
      [[1,1],[1,1]]
    ]
    out = [[1], [0], [0], [1]] # sude, liche, sude, liche
    # Vytvoření tensorů
    input = Nx.tensor(input)
    labels = Nx.tensor(out)

    { %{"x1" => input}, labels }
  end

  def train_model(model, data, epochs) do
    model
    |> Axon.Loop.trainer(:mean_squared_error, Polaris.Optimizers.adam(learning_rate: 0.01))
    |> Axon.Loop.run(data, %{}, epochs: epochs, iterations: 20)
  end
end

model = Axon.input("x1")
|> Axon.conv(4)
|> Axon.dense(4)
|> Axon.flatten
|> Axon.dense(1)

data = Stream.repeatedly(fn -> Model.batch() end)

model_state = Model.train_model(model, data, 10)

Axon.predict(model, model_state, %{"x1" => Nx.tensor([[[2,2],[2,2]]])})
|> IO.inspect()

Axon.predict(model, model_state, %{"x1" => Nx.tensor([[[1,1],[1,1]]])})
|> IO.inspect()
