defmodule PackageManager.CMake.Builder.DependencyTest do
  use ExUnit.Case
  alias PackageManager.CMake.Builder.Dependency
  alias PackageManager.PackageConfig

  describe "build_deps/1" do
    test "builds git dependency when valid params provided" do
      expectation = """
      ExternalProject_Add(json
        GIT_REPOSITORY "hello"
        PREFIX "${DEPS_DIR}/json"
        CMAKE_CACHE_ARGS
          "-DBUILD_SHARED_LIBS:BOOL=true"
          "-DCMAKE_INSTALL_PREFIX:PATH=${BUILD_DIR}"
        UPDATE_COMMAND ""
      )
      """

      assert [expectation] ==
               Dependency.build_deps(%PackageConfig{
                 app: :my_app,
                 deps: [
                   %{
                     name: :json,
                     git: "hello",
                     cache: [
                       build_shared_libs: false
                     ]
                   }
                 ]
               })
    end

    test "builds url dependency when valid params provided" do
      expectation = """
      ExternalProject_Add(json
        URL "hello"
        PREFIX "${DEPS_DIR}/json"
        CMAKE_CACHE_ARGS
          "-DBUILD_SHARED_LIBS:BOOL=true"
          "-DCMAKE_INSTALL_PREFIX:PATH=${BUILD_DIR}"
        UPDATE_COMMAND ""
        BUILD_COMMAND "./otp"
        CONFIGURE_COMMAND "test"
      )
      """

      assert [expectation] ==
               Dependency.build_deps(%PackageConfig{
                 app: :my_app,
                 deps: [
                   %{
                     name: :json,
                     url: "hello",
                     configure: "test",
                     build: "./otp",
                     cache: [
                       build_shared_libs: false
                     ]
                   }
                 ]
               })
    end

    test "builds from url with bare minimum requirement" do
      expectation = """
      ExternalProject_Add(json
        URL "hello"
        PREFIX "${DEPS_DIR}/json"
        CMAKE_CACHE_ARGS
          "-DBUILD_SHARED_LIBS:BOOL=true"
          "-DCMAKE_INSTALL_PREFIX:PATH=${BUILD_DIR}"
        UPDATE_COMMAND ""
      )
      """

      assert [expectation] ==
               Dependency.build_deps(%PackageConfig{
                 app: :my_app,
                 deps: [
                   %{
                     name: :json,
                     url: "hello"
                   }
                 ]
               })
    end

    test "builds git dependency with minimal requirement" do
      expectation = """
      ExternalProject_Add(json
        GIT_REPOSITORY "hello"
        PREFIX "${DEPS_DIR}/json"
        CMAKE_CACHE_ARGS
          "-DBUILD_SHARED_LIBS:BOOL=true"
          "-DCMAKE_INSTALL_PREFIX:PATH=${BUILD_DIR}"
        UPDATE_COMMAND ""
      )
      """

      assert [expectation] ==
               Dependency.build_deps(%PackageConfig{
                 app: :my_app,
                 deps: [
                   %{
                     name: :json,
                     git: "hello"
                   }
                 ]
               })
    end
  end
end
