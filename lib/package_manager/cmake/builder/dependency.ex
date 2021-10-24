defmodule PackageManager.CMake.Builder.Dependency do
  alias PackageManager.PackageConfig

  def build_links(%PackageConfig{deps: deps, app: app}) do
    specs =
      deps
      |> Enum.map(fn %{name: name} ->
        "add_dependencies(#{app} #{name})"
      end)

    specs
  end

  def build_deps(%PackageConfig{deps: deps}) do
    specs =
      deps
      |> Enum.map(&dependency_spec/1)

    specs
  end

  defp dependency_spec(%{git: _, name: _name} = dependency) do
    __MODULE__.Git.build(dependency)
  end

  defp dependency_spec(%{url: _url, name: _name} = dependency) do
    __MODULE__.URL.build(dependency)
  end

  defp dependency_spec(_) do
    raise ArgumentError, "Dependency must either be git or archive link"
  end
end
