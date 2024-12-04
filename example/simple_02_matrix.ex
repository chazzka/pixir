# mix run example/simple_01_row.ex

# EXLA.Backend.set_default(:cuda)

defmodule Helper do
  def generate_sequence(n) when is_integer(n) and n > 0 do
    0..n
    |> Enum.map(fn k -> List.duplicate(0, n - k) ++ List.duplicate(1, k) end)
  end

  def generate_sequence_2D(n) do
    Helper.generate_sequence(n)
    |> Enum.map(fn arr ->
      Enum.map(arr, fn prvek -> [prvek, prvek] end)
    end)
  end
end



defmodule MyModel do
  def model() do
    Axon.input("x1")
    #|> Axon.conv(4, kernel_size: {2})
    #|> Axon.dense(4) #neni potreba skryta, jednoduchy ukol
    |> Axon.flatten
    |> Axon.dense(1)
  end

  def batch do
    input = Helper.generate_sequence_2D(10)
    |> IO.inspect
    labels = 10..0//-1 |> Enum.map(& [&1/10]) |> Enum.to_list
    input = Nx.tensor(input)
    y = Nx.tensor(labels)
    { %{"x1" => input}, y}
  end

  defp train_model(model, data, epochs) do
    model
    |> Axon.Loop.trainer(:mean_squared_error, Polaris.Optimizers.adam(learning_rate: 0.05))
    |> Axon.Loop.run(data, %{}, epochs: epochs, iterations: 10)
  end

  def run do
    model = model()
    data = Stream.repeatedly(&batch/0)

    model_state = train_model(model, data, 15)

    Axon.predict(model, model_state, %{"x1" => Nx.tensor([
      [[0,0], [0,0],[1,1],[1,1],[1,1], [1,1],[1,1], [1,1], [1,1], [1,1]],
      [[0,0], [0,0],[0,0],[0,0],[1,1], [1,1],[1,1], [1,1], [1,1], [1,1]]
    ])})
    |> IO.inspect()

  end
end

#MyModel.batch()
MyModel.run()

# input = [
#   [
#     [0, 0],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1]
#   ],
#   [
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1],
#     [1, 1]
#   ]
# ]

# tensor = Nx.tensor(input)
# |> IO.inspect
