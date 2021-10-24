defmodule PackageManager.CLI.ConfigBuilder do
  alias PackageManager.PackageConfig

  @package_file "package.exs"

  @doc """
  Builds config from package.exs

  ### Example
    iex> build()
    %PackageConfig{}
  """
  def build() do
    {{:module, module, _binary, _deps}, _} = Code.eval_file(@package_file)

    module.project()
    |> PackageConfig.prepare()
    |> PackageConfig.cast!()
  end
end
