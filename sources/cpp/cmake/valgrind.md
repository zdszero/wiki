% valgrind
% zdszero
% 2022-07-14

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
