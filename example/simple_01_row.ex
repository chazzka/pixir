# mix run example/simple_01_row.ex

defmodule MyModel do
  def model() do
    Axon.input("x1", shape: {1,10})
    |> Axon.dense(30)
    |> Axon.dense(10)
    |> Axon.dense(1)
  end

  def batch do
    input = Helper.generate_sequence(10)
    labels = 10..0//-1 |> Enum.map(& [&1/10]) |> Enum.to_list
    input = Nx.tensor(input)
    y = Nx.tensor(labels)
    { %{"x1" => input}, y}
  end

  defp train_model(model, data, epochs) do
    model
    |> Axon.Loop.trainer(:mean_squared_error, Polaris.Optimizers.adam(learning_rate: 0.05))
    |> Axon.Loop.run(data, %{}, epochs: epochs, iterations: 100)
  end

  def run do
    model = model()
    data = Stream.repeatedly(&batch/0)

    model_state = train_model(model, data, 50)

    Axon.predict(model, model_state, %{"x1" => Nx.tensor([[0, 0, 1, 1, 1, 1, 1, 1, 1, 1]])})
    |> IO.inspect()

  end
end

MyModel.run()
