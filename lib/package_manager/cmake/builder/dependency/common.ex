defmodule PackageManager.CMake.Builder.Dependency.CommonParams do
  import PackageManager.Utils

  @default_cmake_cache_args %{
    build_shared_libs: true,
    install_prefix_path: "${BUILD_DIR}"
  }

  @params_map %{
    configure: "CONFIGURE_COMMAND",
    build: "BUILD_COMMAND"
  }

  @params Map.keys(@params_map)

  def build(dependency) do
    [
      download_prefix_path(dependency),
      build_cache_args(dependency),
      add_update_command(dependency)
    ]
    |> Kernel.++(build_params(dependency))
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n")
  end

  defp build_params(%{} = dependency) do
    dependency
    |> Map.keys()
    |> MapSet.new()
    |> MapSet.intersection(MapSet.new(@params))
    |> Enum.map(fn key ->
      param(key, Map.get(@params_map, key), Map.get(dependency, key))
    end)
  end

  defp param(_, key, value) when is_binary(value) do
    "#{key} \"#{value}\""
  end

  defp param(_, key, value) when not is_nil(value) do
    "#{key} #{value}"
  end

  defp param(_, _, _) do
    nil
  end

  defp download_prefix_path(%{prefix: prefix}) do
    "PREFIX \"#{prefix}\""
  end

  defp download_prefix_path(%{name: name}) do
    "PREFIX \"${DEPS_DIR}/#{name}\""
  end

  defp build_cache_args(%{cache: cache}) when is_list(cache) do
    do_build_cache_args(cache)
  end

  defp build_cache_args(_dependency) do
    do_build_cache_args(%{})
  end

  defp do_build_cache_args(cache) do
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
