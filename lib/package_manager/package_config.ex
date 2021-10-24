defmodule PackageManager.PackageConfig do
  use Xema

  # alias PackageManager.PackageConfig.Dependency
  alias PackageManager.PackageConfig.Compiler

  xema do
    field(:app, :atom)
    field(:version, :string)
    field(:output_directory, :string, default: "out")
    field(:cmake_version, :float, default: 3.9)
    field(:type, :atom, enum: [:executable, :library])
    field(:kind, :atom, enum: [:static, :shared], default: :shared)
    field(:files, :list, items: :string)
    field(:deps, :list, items: map())
    field(:compiler, Compiler)

    required([:app, :version, :type, :files])
  end

  @doc """
  Transforms easy to write config to easy deal with format

  ### Example
    iex> prepare([deps: [abc: [], d: []]])
    [deps: [%{name: :abc}, %{name: :d}]]
  """
  def prepare(params) do
    tranfsform_deps(params)
  end

  defp tranfsform_deps(params) do
    deps = Keyword.get(params, :deps)

    deps =
      deps
      |> Enum.map(fn {name, dep} ->
        Keyword.put(dep, :name, name)
        |> Enum.into(%{})
      end)

    Keyword.put(params, :deps, deps)
  end
end
