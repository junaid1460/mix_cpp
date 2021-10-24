defmodule PackageManager.Utils do
  def indent(string, spaces \\ 2) do
    spaces = spaces(spaces)

    string
    |> String.split("\n")
    |> Enum.map(&(spaces <> &1))
    |> Enum.join("\n")
  end

  defp spaces(spaces) do
    1..spaces |> Enum.map(fn _ -> " " end) |> Enum.join()
  end
end
