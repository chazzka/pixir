alias Evision.Mat
alias Nx

# prepare matrices 6x white
whites = Enum.map(1..6, fn _ -> Mat.full({1,1}, 255, :u8) end)
# prepare matrices 4x black
blacks = Enum.map(1..4, fn _ -> Mat.full({1,1}, 0, :u8) end)

paths = Enum.map(0..9, fn n -> "example/out/image#{n}.png" end)

Enum.zip(whites ++ blacks, paths) |> Enum.each(fn {matrix, path} -> Evision.imwrite(path, matrix) end)
