defmodule ProdopsEx.MixProject do
  use Mix.Project

  @source_url "https://github.com/revelrylabs/prodops_ex"

  def project do
    [
      app: :prodops_ex,
      description: "An SDK for interacting with the ProdOps API",
      license: "MIT",
      version: "0.2.0",
      elixir: "~> 1.12",
      deps: deps(),
      compilers: [:yecc, :leex] ++ Mix.compilers(),
      aliases: aliases(),
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => @source_url},
      ],

      # Docs
      name: "ProdopsEx",
      source_url: @source_url,
      docs: [
        main: "readme",
        logo: "prodops-logo.png",
        extras: ["README.md", "LICENSE", "CONTRIBUTING.md", "RELEASES.md", "CODE_OF_CONDUCT.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [docs: ["docs", &copy_logo/1]]
  end

  defp copy_logo(_) do
    File.cp!("./prodops-logo.png", "./doc/prodops-logo.png")
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.29", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 2.2"},
      {:jason, "~> 1.2"},
      {:mimic, "~> 1.7", only: :test},
      {:nimble_options, "~> 1.0"},
      {:styler, "~> 0.7", only: [:dev, :test], runtime: false}
    ]
  end
end
