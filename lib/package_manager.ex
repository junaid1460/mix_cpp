defmodule PackageManager do
  @table :project
  @root_dir_key :root_dir
  @build_dir "_build"
  @outdir_key "_build"
  def set_current_directory!(dir) do
    insert(@root_dir_key, dir)
  end

  def set_out_dir!(dir) do
    insert(@outdir_key, dir)
  end

  defp insert(key, value) do
    init_table!()
    :ets.insert(@table, {key, value})
  end

  defp init_table! do
    if :ets.info(@table) == :undefined do
      :ets.new(@table, [:named_table, :set, :public, {:read_concurrency, true}])
    end
  end

  @doc """
    ### Example
    iex> set_current_directory!("my dir")
    true
    iex> build_dir()
    "my dir/_build"
  """
  def build_dir do
    "#{root_dir()}/#{@build_dir}"
  end

  def cmake_deps_dir() do
    "#{PackageManager.build_dir()}/deps"
  end

  def cmake_deps_dir_name() do
    "CMAKE_DEPS_DIR"
  end

  def cmake_build_dir() do
    "#{PackageManager.build_dir()}/build"
  end

  def cmake_build_dir_name() do
    "CMAKE_BUILD_DIR"
  end

  def cmake_out_dir do
    "#{PackageManager.build_dir()}/out"
  end

  def cmake_out_dir_name do
    "CMAKE_OUT_DIR"
  end

  def cmake_dir() do
    "#{PackageManager.build_dir()}/cmake"
  end

  def root_dir do
    :ets.lookup(@table, @root_dir_key) |> Keyword.get(@root_dir_key)
  end
end
