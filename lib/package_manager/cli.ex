defmodule PackageManager.CLI do
  alias PackageManager.CLI.{CMakeListsBuilder, ProjectRunner, ConfigBuilder, ProjectBuilder}

  @help_message """

  cpm {command}

  commands:
    - gen: generates cmake file
    - build: generates cmake and build
    - run: builds and runs project

  """

  def main(args) do
    PackageManager.set_current_directory!(File.cwd!())
    exec(args)
  end

  def exec(["gen"]), do: dispatch(:gen)
  def exec(["build"]), do: dispatch(:build, "all")
  def exec(["build", target]), do: dispatch(:build, target)
  def exec(["run"]), do: dispatch(:run)
  def exec(_), do: IO.puts(@help_message)

  defp dispatch(:run) do
    build_config!()
    |> build_cmake!()
    |> run_project!()
  end

  defp dispatch(:gen) do
    build_config!()
    |> build_cmake!()
  end

  defp dispatch(:build, target) do
    build_config!()
    |> build_cmake!()

    build_project!(target)
  end

  defdelegate build_project!(config), to: ProjectBuilder, as: :build
  defdelegate run_project!(config), to: ProjectRunner, as: :run
  defdelegate build_cmake!(config), to: CMakeListsBuilder, as: :build
  defdelegate build_config!, to: ConfigBuilder, as: :build
end
