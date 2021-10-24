defmodule PackageManager.CMake do
  alias PackageManager.CMake.Builder
  defdelegate build(config), to: Builder
end
