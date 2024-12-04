defmodule RGB do
  @moduledoc """
  A module for representing RGB color values.

  ## Examples

      iex> rgb = %RGB{R: 255, G: 128, B: 64}
      iex> RGB.to_list(rgb)
      [255, 128, 64]
  """

  defstruct R: 0, G: 0, B: 0

  @doc """
  Converts an `%RGB{}` struct into a list of [R, G, B] values.

  ## Examples

      iex> RGB.to_list(%RGB{R: 10, G: 20, B: 30})
      [10, 20, 30]
  """
  def to_list(%{R: r, G: g, B: b}) do
    [r, g, b]
  end
end

defmodule Frame do
  @moduledoc """
  A module for representing a frame of RGB values.

  ## Examples

      iex> frame = %Frame{
      ...>   RGBs: [
      ...>     [%RGB{R: 10, G: 20, B: 30}, %RGB{R: 20, G: 30, B: 50}],
      ...>     [%RGB{R: 11, G: 21, B: 31}, %RGB{R: 25, G: 30, B: 40}]
      ...>   ]
      ...> }
      iex> Frame.to_list(frame)
      [
        [[10, 20, 30], [20, 30, 50]],
        [[11, 21, 31], [25, 30, 40]]
      ]
  """

  defstruct RGBs: [[]]

  @doc """
  Converts a `%Frame{}` struct into a nested list of RGB values.

  ## Examples

      iex> frame = %Frame{
      ...>   RGBs: [
      ...>     [%RGB{R: 5, G: 10, B: 15}, %RGB{R: 20, G: 25, B: 30}],
      ...>     [%RGB{R: 35, G: 40, B: 45}, %RGB{R: 50, G: 55, B: 60}]
      ...>   ]
      ...> }
      iex> Frame.to_list(frame)
      [
        [[5, 10, 15], [20, 25, 30]],
        [[35, 40, 45], [50, 55, 60]]
      ]
  """
  def to_list(%{RGBs: vnitrek}) do
    vnitrek
    |> Enum.map(fn row -> row |> Enum.map(&RGB.to_list/1) end)
  end
end

defmodule Spot do
  @moduledoc """
  A module for representing a spot, which contains multiple frames.

  ## Examples

      iex> spot = %Spot{
      ...>   Frames: [
      ...>     %Frame{
      ...>       RGBs: [
      ...>         [%RGB{R: 10, G: 20, B: 30}, %RGB{R: 20, G: 30, B: 50}],
      ...>         [%RGB{R: 11, G: 21, B: 31}, %RGB{R: 25, G: 30, B: 40}]
      ...>       ]
      ...>     }
      ...>   ]
      ...> }
      iex> Spot.to_list(spot)
      [
        [
          [[10, 20, 30], [20, 30, 50]],
          [[11, 21, 31], [25, 30, 40]]
        ]
      ]
  """

  defstruct Frames: []

  @doc """
  Converts a `%Spot{}` struct into a nested list of frame data.

  ## Examples

      iex> spot = %Spot{
      ...>   Frames: [
      ...>     %Frame{
      ...>       RGBs: [
      ...>         [%RGB{R: 1, G: 2, B: 3}, %RGB{R: 4, G: 5, B: 6}],
      ...>         [%RGB{R: 7, G: 8, B: 9}, %RGB{R: 10, G: 11, B: 12}]
      ...>       ]
      ...>     }
      ...>   ]
      ...> }
      iex> Spot.to_list(spot)
      [
        [
          [[1, 2, 3], [4, 5, 6]],
          [[7, 8, 9], [10, 11, 12]]
        ]
      ]
  """
  def to_list(%{Frames: poleFramu}) do
    poleFramu
    |> Enum.map(&Frame.to_list/1)
  end
end
