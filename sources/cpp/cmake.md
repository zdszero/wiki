% cmake
% zdszero
% 2022-07-14

## variables

__setting vars__

```
set(VAR SOURCES)
file(GLOB SRC *.cpp)
option(var "help text" value)
target_sources(target SCOPE items)
```

__internal vars__

```
${PROJECT_SOURCE_DIR}    # the path to CMakeLists.txt which contains the project()
${CMAKE_SOURCE_DIR}      # top level CMakeLists.txt path
${CMAKE_BINARY_DIR}      # build or Debug dir path
${CMAKE_TEST_COMMAND}
${CMAKE_INSTALL_PREFIX}  # This variable defaults to /usr/local on UNIX and c:/Program Files on Windows.
```

## include

```
include_directories()
target_include_directories(target SCOPE include_dir)
```

__SCOPE__: 在构建每个target时，cmake都会自动创建两个变量 `INCLUDE_DIRECTORIES` 和 `INTERFACE_INCLUDE_DIRECTORIES` 来存放头文件的位置，当该target被另外一个target2所依赖时，`INTERFACE_INCLUDE_DIRECTORIES` 中所包含的头文件的位置会被自动添加到target2中，我们可以将其类比为两个篮子，一个篮子给自己用，一个篮子给别人用。

PUBLIC|PRIVATE|INTERFACE 就是在指定将定义的 INCLUDE DIR 放置到哪个篮子，或者两个都放。

* PUBLIC: 将 include dir 放到两个篮子中，自己用，也给别人用。
* PRIVATE: 将 include dir 只放到自己的篮子中。
* INTERFACE: 将 include dir 只放到别人的篮子中。

## library

```
# build library
add_library(lib [STATIC | SHARED | MODULE] [EXCLUDE_FROM_ALL] [...])

add_library(lib "")
target_sources(lib SCOPE items)

# link
target_link_library(target SCOPE libs)
```

## subdirectory

```
# CMakeLists in subdir
add_subdirectory(subdir)
```

## install

```
install(TARGETS lib
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
        PUBLIC_HEADER DESTINATION include)
```

when we call `make install`, the library will be installed to `/usr/lib` by default, header files will be installed to `/usr/include` by default

## third parties

## cmdline options

- `CMAKE_C_COMPILER` - The program used to compile c code.
- `CMAKE_CXX_COMPILER` - The program used to compile c++ code.
- `CMAKE_LINKER` - The program used to link your binary.

```
cmake .. -DCMAKE_C_COMPILER=clang-3.6 -DCMAKE_CXX_COMPILER=clang++-3.6
```

## expand functions

## cross platform

## tricks

* [format](./cmake/format.md)
* [valgrind](./cmake/valgrind.md)
* [build all tests](./cmake/build_all_tests.md)
