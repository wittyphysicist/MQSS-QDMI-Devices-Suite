# setup.py

from setuptools import setup, Extension
from Cython.Build import cythonize
import os

from setuptools import setup, Extension
from Cython.Build import cythonize

ext_modules = [
    Extension(
        "qaptiva",
        ["qaptiva.pyx", "qaptiva_qdmi/device.c"],
        include_dirs=["."],
    )
]

setup(
    name="qaptiva",
    ext_modules=cythonize(ext_modules),
)
