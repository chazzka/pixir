defmodule Model do
  def batch(input, out) do
    # Vytvoření tensorů
    # input = Nx.tensor(input)
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


  {_, images} = File.ls("example/out")

  input = images
  |> Stream.map(&Path.join("example/out", &1))
  |> Enum.sort
  |> Enum.map(&Evision.imread(&1))
  |> Enum.map(fn image -> Evision.Mat.to_nx(image) end)
  |> Enum.map(&Nx.backend_transfer(&1, Nx.BinaryBackend))
  |> then(fn image -> Nx.concatenate(image) end)
  |> then(fn tensor -> tensor |> Nx.new_axis(0) end)
  |> IO.inspect


{_, images2} = File.ls("example/out2")

  input2 = images2
  |> Stream.map(&Path.join("example/out2", &1))
  |> Enum.sort
  |> Enum.map(&Evision.imread(&1))
  |> Enum.map(fn image -> Evision.Mat.to_nx(image) end)
  |> Enum.map(&Nx.backend_transfer(&1, Nx.BinaryBackend))
  |> then(fn image -> Nx.concatenate(image) end)
  |> then(fn tensor -> tensor |> Nx.new_axis(0) end)
  |> IO.inspect

out = [[5],[1]] # R, F

data = Stream.repeatedly(fn -> Model.batch(Nx.concatenate([input, input2]), out) end)

model_state = Model.train_model(model, data, 10)




Axon.predict(model, model_state, %{"x1" => Nx.concatenate([input, input2])})
|> IO.inspect
