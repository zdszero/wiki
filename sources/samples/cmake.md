% cmake
% zdszero
% 2022-07-17

* __tests__

```cmake
file(GLOB TEST_SOURCES "${PROJECT_SOURCE_DIR}/test/*.cpp") # test files

add_custom_target(build-tests COMMAND ${CMAKE_CTEST_COMMAND} --show-only)
add_custom_target(check-tests COMMAND ${CMAKE_CTEST_COMMAND} --verbose)

foreach(test_source ${T})
	get_filename_component(test_filename ${test_source} NAME)
	string(REPLACE ".cpp" "" test_name ${test_filename})

	# Add the test target separately and as part of "make check-tests".
	add_executable(${test_name} EXCLUDE_FROM_ALL ${test_source})
	add_dependencies(build-tests ${test_name})
	add_dependencies(check-tests ${test-name})

	target_link_libraries(${test_name} gtest gmock_main)

	set_target_properties(
		${test_name}
		PROPERTIES
		RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/test"
		COMMAND ${test_name}
	)

	# Add the test under CTest
	add_test(
		${test_name}
		--gtest_color=yes
		# --gtest_output=xml:${CMAKE_BINARY_DIR}/test/${test_name}.xml # generate test report
	)
endforeach(test_source $\{$1\})
```

* __format__

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

* __valgrind__

```cmake
find_program(VALGRIND_BIN valgrind)
if ("${VALGRIND_BIN}" STREQUAL "VALGRIND_BIN-NOTFOUND")
	message(WARNING "BusTub/test couldn't find valgrind.")
else()
	message(STATUS "BusTub/test found valgrind at ${VALGRIND_BIN}")
endif()

find_program(VALGRIND_BIN valgrind)
if ("${VALGRIND_BIN}" STREQUAL "VALGRIND_BIN-NOTFOUND")
	message(WARNING "CMake couldn't find valgrind.")
else()
	message(STATUS "CMake found valgrind at ${VALGRIND_BIN}")
endif()

set(
	VALGRIND_OPTIONS
	--error-exitcode=1                      # if leaks are detected, return nonzero value
	# --gen-suppressions=all  # uncomment for leak suppression syntax
	--leak-check=full                       # detailed leak information
	--soname-synonyms=somalloc=*jemalloc*   # also intercept jemalloc
	--trace-children=yes                    # trace child processes
	--track-origins=yes                     # track origin of uninitialized values
)

# set(VALGRIND_SUPPRESSIONS_FILE "${PROJECT_SOURCE_DIR}/build_support/valgrind.supp")

# use valgrind to check test case
add_test(
	${test_name}
	${VALGRIND_BIN} ${VALGRIND_OPTIONS}
	# --suppression=${VALGRIND_SUPPRESSIONS_FILE}
	${CMAKE_BINARY_DIR}/test/${test_name}   # test case path
	--gtest_color=yes
	# --gtest_output=xml:${CMAKE_BINARY_DIR}/test/unit_${test_name}.xml
)
```
