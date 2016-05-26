defmodule Secure.Mixfile do
  use Mix.Project

  def project do
    [app: :secure,
     version: "0.0.1",
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

  defp deps do
    [{:bcrypt, github: "chef/erlang-bcrypt"}]
  end

  defp package do
    [
     name: :secure,
     files: ["lib", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Martin Manelli"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/manelli/secure.ex",
              "Docs" => "https://hexdocs.pm/secure"}]
  end

end
