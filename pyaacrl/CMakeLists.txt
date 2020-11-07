find_package(PythonExtensions REQUIRED)
find_package(Cython REQUIRED)
add_cython_target(cythonized_pyaacrl CXX pyaacrl.pyx)


add_library(pyaacrl MODULE ${cythonized_pyaacrl})
python_extension_module(pyaacrl)
target_link_libraries(pyaacrl yaacrl)
install(TARGETS pyaacrl LIBRARY DESTINATION pyaacrl)