defmodule PackageManager.CMake.Builder.Dependency.URL do
  import PackageManager.Utils
  alias PackageManager.CMake.Builder.Dependency.CommonParams

  @url_params [
    :url
  ]

  def build(%{name: name} = dependency) do
    params =
      [build_url_params(dependency), add_common_params(dependency)]
      |> Enum.map(&indent(&1))
      |> Enum.join("\n")

    """
    ExternalProject_Add(#{name}
    #{params}
    )
    """
  end

  defp build_url_params(dependency) do
    dependency
    |> Map.keys()
    |> MapSet.new()
    |> MapSet.intersection(MapSet.new(@url_params))
    |> Enum.map(fn key ->
      build_url_param(key, Map.get(dependency, key))
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n")
  end

  defp build_url_param(:url, ""), do: raise(ArgumentError, "URL must not be empty")

  defp build_url_param(:url, url) do
    "URL \"#{url}\""
  end

  defp add_common_params(dependency) do
    CommonParams.build(dependency)
  end
end
