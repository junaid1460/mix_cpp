defmodule Mix.MyProject do
  def project do
    [
      app: :my_app,
      version: "0.1.0",
      deps: deps(),
      compiler: compiler(),
      type: :executable,
      kind: :shared,
      output_directory: "out",
      files: files()
    ]
  end

  defp compiler do
    [
      cxx_standard: 20
    ]
  end

  defp files do
    [
      "main.cpp"
    ]
  end

  defp deps do
    [
      {:json,
       git: "https://github.com/nlohmann/json.git",
       tag: "f5b3fb326c1a651cd3e62201b0e7074cf987f748"},
      {:pegtl,
       git: "https://github.com/taocpp/PEGTL.git", tag: "f98ead1d1fd38c447038327c1c4c0b51c90b90f1"},
      {:curl, url: "https://curl.se/download/curl-7.77.0.tar.gz"},
      {:erlang,
       git: "https://github.com/erlang/otp.git", tag: "f7d00dd023b15ab787a5f420a263dd320914213a"}
    ]
  end
end
