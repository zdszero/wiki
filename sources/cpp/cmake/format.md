% format
% zdszero
% 2022-07-14

```cmake
##########################################
# "make format"
# "make check-format"
##########################################
find_program(CLANG_FORMAT_BIN clang-format)
if ("${CLANG_FORMAT_BIN}" STREQUAL "CLANG_FORMAT_BIN-NOTFOUND")
	message(WARNING "CMake couldn't find clang-format")
else()
	message(STATUS "CMake found clang-format at ${CLANG_FORMAT_BIN}")
endif()

file(
	GLOB_RECURSE FORMAT_FILES
	${PROJECT_SOURCE_DIR}/src/*.cpp
	${PROJECT_SOURCE_DIR}/src/*.h
	${PROJECT_SOURCE_DIR}/test/*.cpp
	${PROJECT_SOURCE_DIR}/test/*.h
)

add_custom_target(
	format
	echo "${FORMAT_FILES}" | xargs -n12 -P8
	${CLANG_FORMAT_BIN}
	-i
)

# use scirpt to run clang-format
string(
	CONCAT
	FORMAT_DIRS
	"${PROJECT_SOURCE_DIR}/src "
	"${PROJECT_SOURCE_DIR}/test"
)

string(
	CONAT
	FORMAT_EXCLUDE_DIRS
	"${PROJECT_SOURCE_DIR}/src/third_party"
)

add_custom_target(
	format
	${BUILD_SUPPORT_DIR}/run-clang-format.py
	-r
	--exclude ${FORMAT_EXCLUDE_DIRS}
	${FORMAT_DIRS}
)
```
