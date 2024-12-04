defmodule Model do
  def batch(input, out) do
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

input =
  [Spot.to_list(%Spot{
      Frames: [
        %Frame{ # film
          RGBs: [
            [%RGB{R: 10, G: 20, B: 30 }, %RGB{R: 20, G: 30, B: 50 }],
            [%RGB{R: 11, G: 21, B: 31 }, %RGB{R: 25, G: 30, B: 40 }]
         ]
        },
        %Frame{ #film
          RGBs: [
            [%RGB{R: 10, G: 20, B: 30 }, %RGB{R: 20, G: 30, B: 50 }],
            [%RGB{R: 11, G: 21, B: 31 }, %RGB{R: 25, G: 30, B: 40 }]
         ]
        },
        %Frame{ #film
          RGBs: [
            [%RGB{R: 10, G: 20, B: 30 }, %RGB{R: 20, G: 30, B: 50 }],
            [%RGB{R: 11, G: 21, B: 31 }, %RGB{R: 25, G: 30, B: 40 }]
         ]
        },
        %Frame{ # reklama
          RGBs: [
            [%RGB{R: 100, G: 200, B: 255 }, %RGB{R: 20, G: 30, B: 50 }],
            [%RGB{R: 11, G: 21, B: 31 }, %RGB{R: 100, G: 30, B: 40 }]
         ]
        },
        %Frame{ #reklama
          RGBs: [
            [%RGB{R: 100, G: 200, B: 255 }, %RGB{R: 20, G: 30, B: 50 }],
            [%RGB{R: 11, G: 21, B: 31 }, %RGB{R: 100, G: 30, B: 40 }]
         ]
        },
      ]
    }),
    Spot.to_list(%Spot{
      Frames: [
        %Frame{ # F
          RGBs: [
            [%RGB{R: 50, G: 10, B: 30 }, %RGB{R: 20, G: 20, B: 15 }],
            [%RGB{R: 110, G: 15, B: 31 }, %RGB{R: 10, G: 40, B: 14 }]
         ]
        },
        %Frame{ # F
          RGBs: [
            [%RGB{R: 50, G: 10, B: 30 }, %RGB{R: 20, G: 20, B: 15 }],
            [%RGB{R: 110, G: 15, B: 31 }, %RGB{R: 10, G: 40, B: 14 }]
         ]
        },
        %Frame{ # R
          RGBs: [
            [%RGB{R: 1, G: 10, B: 210 }, %RGB{R: 20, G: 30, B: 90 }],
            [%RGB{R: 1, G: 30, B: 31 }, %RGB{R: 150, G: 80, B: 40 }]
         ]
        },
        %Frame{ # R
          RGBs: [
            [%RGB{R: 1, G: 10, B: 210 }, %RGB{R: 20, G: 30, B: 90 }],
            [%RGB{R: 1, G: 30, B: 31 }, %RGB{R: 150, G: 80, B: 40 }]
         ]
        },
        %Frame{ # R
          RGBs: [
            [%RGB{R: 1, G: 10, B: 210 }, %RGB{R: 20, G: 30, B: 90 }],
            [%RGB{R: 1, G: 30, B: 31 }, %RGB{R: 150, G: 80, B: 40 }]
         ]
        }
      ]
    })]

out = [[2], [1]] # R, F

data = Stream.repeatedly(fn -> Model.batch(input, out) end)

model_state = Model.train_model(model, data, 10)

Axon.predict(model, model_state, %{"x1" => Nx.tensor(input)})
|> IO.inspect
