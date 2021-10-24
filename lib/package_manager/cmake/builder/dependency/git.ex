defmodule PackageManager.CMake.Builder.Dependency.Git do
  import PackageManager.Utils

  alias PackageManager.CMake.Builder.Dependency.CommonParams

  @git_params [
    :git,
    :shallow,
    :tag
  ]

  def build(%{git: _, name: name} = dependency) do
    params =
      [build_git_params(dependency), add_common_params(dependency)]
      |> Enum.map(&indent(&1))
      |> Enum.join("\n")

    """
    ExternalProject_Add(#{name}
    #{params}
    )
    """
  end

  defp build_git_params(%{} = dependency) do
    dependency
    |> Map.keys()
    |> MapSet.new()
    |> MapSet.intersection(MapSet.new(@git_params))
    |> Enum.map(fn key ->
      git_param(key, Map.get(dependency, key))
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n")
  end

  defp git_param(_, ""), do: nil

  defp git_param(:git, value) do
    "GIT_REPOSITORY \"#{value}\""
  end

  defp git_param(:tag, value) do
    "GIT_TAG \"#{value}\""
  end

  defp git_param(:shallow, value) do
    "GIT_SHALLOW #{!!value}"
  end

  defp git_param(option, _value) do
    raise ArgumentError, "invalid option for git '#{option}'"
  end

  defp add_common_params(dependency) do
    CommonParams.build(dependency)
  end
end
