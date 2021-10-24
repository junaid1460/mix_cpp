defmodule PackageManager.CLI.ProjectBuilder do
  @cmake_dir "_build/_cmake"

  @doc """
  Builds config from package.exs

  ### Example
    iex> build()
    %PackageConfig{}
  """
  def build(target \\ "") when is_binary(target) do
    project_dir = File.cwd!()
    File.mkdir_p!(@cmake_dir)
    File.cd!(@cmake_dir)

    System.cmd("cmake", ["#{project_dir}"], into: IO.stream())
    System.cmd("make", ["#{target}"], into: IO.stream())
  end
end
