# nacteme obrazek a dame ho do matice

defmodule Helper do
  def pathtonx(path) do
    Evision.imread(path)
    #|> Evision.Mat.to_nx
  end
end


# ted pro vice obrazku, nachystame path
{_, images} = File.ls("example/out")

inputs = images
|> Stream.map(&Path.join("example/out", &1))
|> Enum.sort
|> Enum.map(&Helper.pathtonx/1)
|> IO.inspect


# labels = Nx.tensor([0, 0, 0, 0, 0, 0, 1, 1, 1, 1])
