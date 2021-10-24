defmodule PackageManager.CLI.ProjectRunner do
  alias PackageManager.PackageConfig

  @doc """
  C++ Package CLI

  ### Example
    iex> main(%{})
    {:ok, :written}
  """
  def run(%PackageConfig{} = config) do
    config
  end
end
