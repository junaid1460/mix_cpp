defmodule PackageManager.CMake.Builder do
  alias PackageManager.CMake.Builder.Dependency
  alias PackageManager.PackageConfig
  alias PackageManager.PackageConfig.Compiler

  @deps_and_build """
  set(DEPS_DIR "${CMAKE_SOURCE_DIR}/_build/_deps")
  set(BUILD_DIR "${CMAKE_SOURCE_DIR}/_build/_build")
  """

  def build(%PackageConfig{} = config) do
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
    [@deps_and_build | content]
  end

  defp add_project(content, %PackageConfig{app: project}) do
    ["project(#{project})" | content]
  end

  defp add_external_project_support(content) do
    ["include(ExternalProject)" | content]
  end

  defp set_include_dirs(content) do
    ["include_directories(\"\${BUILD_DIR}/include\")" | content]
  end

  defp set_cpp_standard(content, %PackageConfig{compiler: %Compiler{cxx_standard: standard}}) do
    ["set(CMAKE_CXX_STANDARD #{standard})" | content]
  end

  defp add_target(content, %PackageConfig{type: :executable, files: files, app: app}) do
    files = Enum.join(files, " ")
    ["add_executable(#{app} #{files})" | content]
  end

  defp add_target(content, %PackageConfig{type: :library, kind: kind, files: files, app: app}) do
    files = Enum.join(files, " ")
    kind = lib_kind(kind)
    ["add_library(#{app} #{kind} #{files})" | content]
  end

  defp lib_kind(:shared), do: "SHARED"
  defp lib_kind(:static), do: "STATIC"

  defp set_out_dir(content, %PackageConfig{app: app, output_directory: dir}) do
    out_dir_spec = """
    set(OUT_DIR ${CMAKE_SOURCE_DIR}/#{dir} )

    set_target_properties(#{app}
      PROPERTIES
      ARCHIVE_OUTPUT_DIRECTORY "${OUT_DIR}"
      LIBRARY_OUTPUT_DIRECTORY "${OUT_DIR}"
      RUNTIME_OUTPUT_DIRECTORY "${OUT_DIR}"
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
end
