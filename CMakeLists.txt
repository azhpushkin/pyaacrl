cmake_minimum_required(VERSION 3.3.0)
project(pyaacrl)

# Top-level CMake creates yaacrl_dependency target, that either
# linkgs system lib or builds from git-submodule sources 
if ($ENV{USE_SYSTEM_YAACRL})
    message("Using system yaacrl library")
    
    add_library(yaacrl_dependency INTERFACE IMPORTED)
    target_link_libraries(yaacrl_dependency INTERFACE yaacrl)
    # NOTE: assume incude headers are installed in system paths
    
else()
    add_subdirectory(vendor/yaacrl EXCLUDE_FROM_ALL)
    add_library(yaacrl_dependency ALIAS yaacrl-static)
    set(YAACRL_LIB_HEADERS
        ${CMAKE_CURRENT_SOURCE_DIR}/vendor/yaacrl/include
        )

endif()    

# pyaacrl subdirectory will inherit current scope
# variables and targets (e.g. yaacrl_dependency)
add_subdirectory(pyaacrl/cython_src)
