defmodule Secure.Mixfile do
  use Mix.Project

  def project do
    [app: :secure,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: "Collection of secure utilities",
     package: package]
  end

  def application do
    [applications: [:logger, :crypto, :bcrypt]]
  end

  def deps do
    [{:bcrypt, "~> 0.5.0-p3a"},
     {:earmark, "~> 0.2", only: :docs},
     {:ex_doc, "~> 0.11", only: :docs}]
  end

  defp package do
    [
     name: :secure,
     maintainers: ["Martin Manelli"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/manelli/secure.ex",
              "Docs" => "https://hexdocs.pm/secure"}]
  end

end
