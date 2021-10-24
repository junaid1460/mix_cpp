defmodule PackageManager.CLI.ProjectBuilder do
  @cmake_dir "cmake"

  @doc """
  Builds config from package.exs

  ### Example
    iex> build()
    %PackageConfig{}
  """
  def build(target \\ "") when is_binary(target) do
    build_dir = PackageManager.build_dir()
    cmake_dir = "#{build_dir}/#{@cmake_dir}"
    File.mkdir_p!(cmake_dir)
    File.cd!(cmake_dir)

    System.cmd("cmake", ["#{build_dir}"], into: IO.stream())
    System.cmd("make", ["#{target}"], into: IO.stream())
  end
end
