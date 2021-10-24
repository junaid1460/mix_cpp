defmodule PackageManager.CMake.Builder.Dependency.CommonParams do
  import PackageManager.Utils

  @default_cmake_cache_args %{
    build_shared_libs: true,
    install_prefix_path: "${BUILD_DIR}"
  }

  def build(dependency) do
    [
      download_prefix_path(dependency),
      build_cache_args(dependency),
      add_update_command(dependency),
      add_configure_command(dependency)
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n")
  end

  defp add_configure_command(%{configure: configure}) do
    "CONFIGURE_COMMAND \"#{configure}\""
  end

  defp add_configure_command(_), do: nil

  defp download_prefix_path(%{prefix: prefix}) do
    "PREFIX \"#{prefix}\""
  end

  defp download_prefix_path(%{name: name}) do
    "PREFIX \"${DEPS_DIR}/#{name}\""
  end

  defp build_cache_args(%{cache: cache}) when is_list(cache) do
    cache_args =
      cache
      |> Enum.into(%{})
      |> Map.merge(@default_cmake_cache_args)
      |> Map.to_list()
      |> Enum.map(fn {key, value} ->
        build_cache_arg(key, value)
      end)
      |> Enum.join("\n")
      |> indent()

    "CMAKE_CACHE_ARGS\n#{cache_args}"
  end

  defp build_cache_arg(:build_shared_libs, value) do
    "\"-DBUILD_SHARED_LIBS:BOOL=#{!!value}\""
  end

  defp build_cache_arg(:install_prefix_path, value) do
    "\"-DCMAKE_INSTALL_PREFIX:PATH=#{value}\""
  end

  defp add_update_command(%{update_command: command}) do
    "UPDATE_COMMAND \"#{command}\""
  end

  defp add_update_command(_) do
    "UPDATE_COMMAND \"\""
  end
end
