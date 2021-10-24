defmodule PackageManager.CLI.CMakeListsBuilder do
  alias PackageManager.CMake
  alias PackageManager.PackageConfig

  @doc """
  C++ Package CLI

  ### Example
    iex> main(%{})
    {:ok, :written}
  """
  def build(%PackageConfig{} = config) do
    content =
      config
      |> CMake.build()

    :ok = File.mkdir_p!(PackageManager.build_dir())

    :ok = File.write!("#{PackageManager.build_dir()}/CMakeLists.txt", content)
    config
  end
end
