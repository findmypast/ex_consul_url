defmodule ExConsulUrl.Mixfile do
  use Mix.Project

  @description """
   Simple url lookup from HashiCorp Consul
  """

  def project do
    [app: :ex_consul_url,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: @description,
     package: package(),
     deps: deps(),
     source_url: "https://github.com/findmypast/ex_consul_url"]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  defp package do
    [# These are the default files included in the package
     maintainers: ["opensource@findmypast.com"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/findmypast/ex_consul_url"}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git`: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.10.0"},
    {:poison, "~> 3.0"},
    {:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
