cmake_minimum_required(VERSION 3.3.0)
project(pyaacrl)


# Add yaacrl first, so pyaacrl subdir has vendor targets in scope
# EXCLUDE_FROM_ALL is used to disable default *build all* behavior
add_subdirectory(vendor/yaacrl EXCLUDE_FROM_ALL)
set(YAACRL_LIB_HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/vendor/yaacrl/include)


add_subdirectory(pyaacrl)
