defmodule CssColors.Mixfile do
  use Mix.Project

  def project do
    [app: :css_colors,
     version: "0.2.2",
     elixir: "~> 1.4",
     deps: deps(),
     source_url: "https://github.com/alvinlindstam/css_colors",
     name: "CssColors",
     package: package(),
     description: description()]
  end

  defp package do
    [maintainers: ["Alvin Lindstam"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/alvinlindstam/css_colors"},
     files: ~w(lib) ++
            ~w(LICENSE mix.exs README.md)]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp description do
    """
    Library for parsing, writing and manipulation (css) colors.
    """
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_parameterized, "~> 1.2.0", only: :test},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:ecto, ">= 2.0.0", optional: :true}
    ]
  end
end
