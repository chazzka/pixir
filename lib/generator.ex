defmodule Generator do
  @moduledoc """
  A module for generating random sequences with options for customization.
  """

  @doc """
  Generates a sequence of lists, where each list contains a random selection of elements from a given list (`klobouk`).

  ## Parameters

    - `n` (default: 5): Number of lists to generate.
    - `n_kraliku` (default: 3): Number of elements to randomly select in each list.
    - `klobouk` (default: `[1, 3, 5, 7, 9]`): The list from which elements are randomly selected.

  ## Examples

      iex> :rand.seed(:exsplus, {1234, 5678, 9012})
      iex> Generator.generate_sequence()
      [9, 5, 7]

      iex> :rand.seed(:exsplus, {1234, 5678, 9012})
      iex> Generator.generate_sequence(2, [10, 20, 30, 40])
      [40, 30]

      iex> :rand.seed(:exsplus, {1234, 5678, 9012})
      iex> Generator.generate_sequence(1, [100, 200])
      [100]

  """
  def generate_sequence(n_kraliku \\ 3, klobouk \\ [1, 3, 5, 7, 9]) do
    Enum.take_random(klobouk, n_kraliku)
  end

  @doc """
  Generates a sequence of lists based on the given parameters.

  ## Parameters

    - `klobouky` (default: `[[1, 3, 5, 7, 9], [0, 2, 4, 6, 8]]`): A list of lists from which elements are randomly selected.
    - `n` (default: `5`): Number of lists to generate for each `klobouk`.
    - `n_kraliku` (default: `[3, 5]`): Number of elements to randomly select from each `klobouk`.
    - `reversed` (default: `false`): If `true`, the resulting sequence is reversed.

  ## Examples

      iex> :rand.seed(:exsplus, {1234, 5678, 9012})
      iex> Generator.generate_sequences()
      [[9, 5, 7], [9, 3, 7], [5, 9, 3], [1, 9, 3], [1, 5, 9], [4, 8, 6], [6, 8, 2], [4, 8, 0], [6, 0, 8], [2, 4, 8]]
  """
  def generate_sequences(
        klobouky \\ [[1, 3, 5, 7, 9], [0, 2, 4, 6, 8]],
        n \\ 5,
        n_kraliku \\ [3, 3],
        reversed \\ false
      ) do
    result =
      Enum.zip(n_kraliku, klobouky)
      |> Enum.flat_map(fn {kralik, klobouk} ->
        Stream.repeatedly(fn -> generate_sequence(kralik, klobouk) end)
        |> Enum.take(n)
      end)

    if reversed, do: Enum.reverse(result), else: result
  end
end
