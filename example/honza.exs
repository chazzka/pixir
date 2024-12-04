defmodule RGB do
  defstruct R: 0, G: 0, B: 0

  def to_list(%{R: r, G: g, B: b}) do
    [r,g,b]
  end
end

defmodule Frame do
  defstruct RGBs: [[]]
  def to_list(%{RGBs: vnitrek}) do
    vnitrek
    |> Enum.map(fn row -> row |> Enum.map(fn item -> RGB.to_list(item) end) end)
  end
end

defmodule Spot do
  defstruct Frames: []
  def to_list(%{Frames: poleFramu}) do
    poleFramu
    |> Enum.map(fn frame -> Frame.to_list(frame) end)
  end
end

defmodule Main do
  _rgb = %RGB{R: 255, G: 128, B: 64}

  spot = %Spot{
    Frames: [
      %Frame{
        RGBs: [
          [%RGB{R: 10, G: 20, B: 30 }, %RGB{R: 20, G: 30, B: 50 }],
          [%RGB{R: 11, G: 21, B: 31 }, %RGB{R: 25, G: 30, B: 40 }]
       ]
      }
    ]
  }

  spot2 = %Spot{
    Frames: [
      %Frame{
        RGBs: [
          [%RGB{R: 5, G: 10, B: 30 }, %RGB{R: 20, G: 30, B: 90 }],
          [%RGB{R: 11, G: 15, B: 31 }, %RGB{R: 150, G: 80, B: 40 }]
       ]
      }
    ]
  }
  IO.inspect(spot)
  IO.inspect(Spot.to_list(spot) ++ Spot.to_list(spot2))
end
