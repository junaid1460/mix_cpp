defmodule PackageManager.PackageConfig.Compiler do
  use Xema

  xema do
    field(:cxx_standard, :integer, default: 11)
  end
end
