import os
import shutil
import subprocess as subproc
from pathlib import Path, PurePath

from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext as build_ext

CPPFLAGS = ['-O2', '-std=c++17', ]
FILE_PATH = Path(__file__).parent.resolve()
YAACRL_DIR: PurePath = FILE_PATH / 'vendor' / 'yaacrl'
YAACRL_BUILD_DIR: PurePath = FILE_PATH / 'build' / 'yaacrl'


class pyaacrl_build_ext(build_ext):
    user_options = build_ext.user_options + [
        (
            'use-system-yaacrl',
            None,
            'If set, use system yaacrl library, instead of the bundled one'
        )
    ]

    boolean_options = build_ext.boolean_options + [
        'use-system-yaacrl',
    ]

    def initialize_options(self):
        if getattr(self, '_initialized', False):
            return

        super().initialize_options()
        self.use_system_yaacrl = False
    
    def _build_yaacrl(self):
        try:
            import Cython
        except ImportError:
            raise RuntimeError('Cython is required to install pyaacrl')

        # Make sure build directory is ready
        YAACRL_BUILD_DIR.mkdir(parents=True, exist_ok=True)
        
        # Reset CMake cache to avoid issues with non-constant build directory
        # Otherwise mixing `python setup.py build_ext` and `pip install`
        # messes CMake configs up
        if (YAACRL_BUILD_DIR / 'CMakeCache.txt').exists():
            os.remove(YAACRL_BUILD_DIR / 'CMakeCache.txt')

        # For some reason, -G argument only works in this way. No idea why.
        subproc.run([
            'cmake', ' -G "Unix Makefiles" ',  '-S', YAACRL_DIR, '-B', YAACRL_BUILD_DIR
        ], check=True)

        # Actually compile a program
        subproc.run(['make'], cwd=YAACRL_BUILD_DIR, check=True)

    def build_extension(self, ext):
        if self.use_system_yaacrl:
            self.compiler.add_library('yaacrl')
        else:
            try:
                subproc.check_call('ldconfig -p | grep hiredis', shell=True)
            except subproc.CalledProcessError:
                raise RuntimeError('hiredis library is required for pyaacrl to work')
            
            self._build_yaacrl()
            ext.extra_objects.extend([str(YAACRL_BUILD_DIR / 'libyaacrl-static.a')])
            
            ext.libraries.extend(['hiredis'])
            self.compiler.add_include_dir(str(YAACRL_DIR / 'include'))
        
        super().build_extension(ext)


setup(
    name='pyaacrl',
    packages=['pyaacrl'],
    cmdclass={
        'build_ext': pyaacrl_build_ext
    },
    ext_modules=[
        Extension(
            'pyaacrl',
            sources=['pyaacrl/pyaacrl.pyx'],
            extra_compile_args=CPPFLAGS,
            language='c++'
        )
    ],
    provides=['pyaacrl'],
    include_package_data=True
)




