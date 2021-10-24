defmodule PackageManager.PackageConfig.Dependency do
  use Xema

  xema do
    field(:git, :string, default: "")
    field(:url, :string, default: "")
    field(:tag, :string, default: "")
    field(:name, :string, default: "")

    required([:name])
  end
end
