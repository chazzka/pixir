defmodule Pixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :pixir,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:evision, "~> 0.2"},
      {:nx, "~> 0.2"},
      {:axon, "~> 0.6"},
      {:randixir, "~> 0.1.0"}
    ]
  end
end
