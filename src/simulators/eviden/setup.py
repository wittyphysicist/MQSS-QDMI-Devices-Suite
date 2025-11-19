# setup.py

# python setup.py build_ext --inplace

from setuptools import setup, Extension
from Cython.Build import cythonize

ext_modules = cythonize(
    [
        Extension(
            "qaptiva",              # or "simulators.eviden.qaptiva" if you have packages
            sources=["qaptiva.pyx"] # <— only the filename, no src/... prefix
        )
    ],
    compiler_directives={"language_level": "3"},
)

setup(
    name="qaptiva",
    ext_modules=ext_modules,
)

