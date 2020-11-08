find_package(PythonExtensions REQUIRED)
find_package(Cython REQUIRED)

add_cython_target(pyaacrl_cy CXX PY3)

add_library(pyaacrl_cy MODULE ${pyaacrl_cy})
target_link_libraries(pyaacrl_cy yaacrl-static)
target_include_directories(pyaacrl_cy PUBLIC ${YAACRL_LIB_HEADERS})

python_extension_module(pyaacrl_cy)
install(TARGETS pyaacrl_cy LIBRARY DESTINATION pyaacrl)
