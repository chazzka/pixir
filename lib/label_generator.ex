defmodule LabelGenerator do
  @moduledoc """
  A module to process sequences (frames) and determine transition points based on parity (even or odd numbers).
  """

  @doc """
  Determines the index where a change in parity distribution occurs between consecutive frames in a list of frames.

  ## Examples

      iex> frames = [
      ...>   [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
      ...>   [[2, 4, 6], [1, 3, 5], [8, 0, 2]],
      ...>   [[0, 2, 4], [6, 8, 10], [1, 3, 7]]
      ...> ]
      iex> LabelGenerator.pruchodmap(frames)
      [0, 0, 1]

  """
  def pruchodmap(snimky) do
    snimky
    |> Enum.map(fn snimek -> pruchod(snimek, 0) end)
  end

  defp pruchod([f, s | tail], index) do
    if hasChanged(f, s), do: index, else: pruchod([s | tail], index + 1)
  end

  defp hasChanged(first, second) do
    sudef =
      first
      |> Enum.group_by(fn x -> rem(x, 2) == 0 end)
      |> then(fn
        %{false: liche, true: sude} -> Enum.count(sude) < Enum.count(liche)
        %{false: _} -> true
        %{true: _} -> false
      end)

    sudes =
      second
      |> Enum.group_by(fn x -> rem(x, 2) == 0 end)
      |> then(fn
        %{false: liche, true: sude} -> Enum.count(sude) < Enum.count(liche)
        %{false: _} -> true
        %{true: _} -> false
      end)

    sudef != sudes
  end
end
