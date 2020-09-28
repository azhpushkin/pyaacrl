import sys
from distutils.core import setup, Extension
from Cython.Build import cythonize

compile_args = ['-g', '-std=c++17']

# TEMP directives, for testing
import pathlib
repo_root = pathlib.Path(__file__).absolute().parent
yaacrl_src_dir = str(repo_root/'vendor'/'yaacrl/src')


vendor_c_files=[
    'vendor/kiss_fft.c',
    'vendor/MurmurHash3.cpp',
    'lib.cpp',
    'spectrogram.cpp',
    'fingerprint.cpp',
]
sources = [
    *[yaacrl_src_dir+'/'+file for file in vendor_c_files],
    'yaacrl/yaacrl.pyx'
]

basics_module = Extension(
    'yaacrl',
    sources=sources,
    extra_compile_args=compile_args,
    libraries=["hiredis"],
    language='c++',
    include_dirs=[yaacrl_src_dir]
)




setup(
    name='yaacrl',
    packages=['yaacrl'],
    ext_modules=cythonize(basics_module, compiler_directives={'language_level' : "3"})
)