% build all tests
% zdszero
% 2022-07-14

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
