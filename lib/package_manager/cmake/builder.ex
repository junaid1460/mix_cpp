defmodule PackageManager.CMake.Builder do
  alias PackageManager.CMake.Builder.Dependency
  alias PackageManager.PackageConfig
  alias PackageManager.PackageConfig.Compiler

  def build(%PackageConfig{} = config) do
    PackageManager.set_out_dir!(config.output_directory)

    []
    |> add_version(config)
    |> add_dependency_dirs()
    |> add_project(config)
    |> add_external_project_support()
    |> set_include_dirs()
    |> set_cpp_standard(config)
    |> add_target(config)
    |> set_out_dir(config)
    |> build_deps(config)
    |> link_deps(config)
    |> construct()
  end

  def construct(content) do
    content
    |> Enum.reverse()
    |> Enum.join("\n\n")
  end

  defp add_version(content, %PackageConfig{cmake_version: version}) do
    ["cmake_minimum_required(VERSION #{version})" | content]
  end

  defp add_dependency_dirs(content) do
    [deps_and_build_dir() | content]
  end

  defp add_project(content, %PackageConfig{app: project}) do
    ["project(#{project})" | content]
  end

  defp add_external_project_support(content) do
    ["include(ExternalProject)" | content]
  end

  defp set_include_dirs(content) do
    ["include_directories(\"\${#{cmake_build_dir_name()}}/include\")" | content]
  end

  defp set_cpp_standard(content, %PackageConfig{compiler: %Compiler{cxx_standard: standard}}) do
    ["set(CMAKE_CXX_STANDARD #{standard})" | content]
  end

  defp add_target(content, %PackageConfig{type: :executable, files: files, app: app}) do
    cwd = PackageManager.root_dir() <> "/"
    files = files |> Enum.map(&(cwd <> &1)) |> Enum.join(" ")
    ["add_executable(#{app} #{files})" | content]
  end

  defp add_target(content, %PackageConfig{type: :library, kind: kind, files: files, app: app}) do
    cwd = PackageManager.root_dir() <> "/"
    files = files |> Enum.map(&(cwd <> &1)) |> Enum.join(" ")
    kind = lib_kind(kind)
    ["add_library(#{app} #{kind} #{files})" |> IO.inspect() | content]
  end

  defp lib_kind(:shared), do: "SHARED"
  defp lib_kind(:static), do: "STATIC"

  defp set_out_dir(content, %PackageConfig{app: app}) do
    out_dir_spec = """
    set(#{out_dir_name()}  \"#{out_dir()}\")

    set_target_properties(#{app}
      PROPERTIES
      ARCHIVE_OUTPUT_DIRECTORY "${#{out_dir_name()}}"
      LIBRARY_OUTPUT_DIRECTORY "${#{out_dir_name()}}"
      RUNTIME_OUTPUT_DIRECTORY "${#{out_dir_name()}}"
    )
    """

    [out_dir_spec | content]
  end

  defp build_deps(content, config) do
    Dependency.build_deps(config) ++ content
  end

  defp link_deps(content, config) do
    Dependency.build_links(config) ++ content
  end

  defp deps_and_build_dir do
    """
    set(#{{cmake_deps_dir_name(), cmake_deps_dir()} |> tuple_to_string})
    set(#{{cmake_build_dir_name(), cmake_build_dir()} |> tuple_to_string})
    """
  end

  defp cmake_deps_dir, do: PackageManager.cmake_build_dir()
  defp cmake_deps_dir_name, do: PackageManager.cmake_build_dir_name()
  defp cmake_build_dir, do: PackageManager.cmake_deps_dir()
  defp cmake_build_dir_name, do: PackageManager.cmake_deps_dir_name()
  defp out_dir, do: PackageManager.cmake_out_dir()
  defp out_dir_name, do: PackageManager.cmake_out_dir_name()

  defp tuple_to_string({param, value}) do
    "#{param} \"#{value}\""
  end
end
