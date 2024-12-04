defmodule Nxpreprocessor do

  defstruct data: nil, size: 0, dimensions: []

  def new(data, dimensions \\ nil) do
    tensor = Nx.tensor(data)
    dims = dimensions || Nx.shape(tensor) |> Tuple.to_list()
    size = Enum.reduce(dims, 1, &(&1 * &2))

    %__MODULE__{
      data: tensor,
      size: size,
      dimensions: dims
    }
  end
  # tento preprocesor prijme pole vygenerovane generatorem a vrati nx tensor a k tomu informace potrebne pro model
  # size atp, mozna nejakou strukturu

  def input_tensor() do

  end

  def labels_tensor() do

  end
end
