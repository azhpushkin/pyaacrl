find_package(PythonExtensions REQUIRED)
find_package(Cython REQUIRED)
set(CMAKE_CXX_STANDARD 17)

add_cython_target(pyaacrl_cy CXX PY3)

add_library(pyaacrl_cy MODULE ${pyaacrl_cy})

# Same linking for both system-wide or local installation
target_link_libraries(pyaacrl_cy yaacrl_dependency)

# For system-linked installation, this will do nothing
target_include_directories(pyaacrl_cy PUBLIC ${YAACRL_LIB_HEADERS})

python_extension_module(pyaacrl_cy)
install(TARGETS pyaacrl_cy LIBRARY DESTINATION pyaacrl)
