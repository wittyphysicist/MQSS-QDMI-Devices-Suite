# setup.py

from setuptools import setup, Extension
from Cython.Build import cythonize
import os

# Path to the .pyx file inside the repo
ext_modules = [
   Extension(
       "simulators.eviden.qaptiva",
       sources=["src/simulators/eviden/qaptiva.pyx"],
   )
]

setup(
   name="qaptiva",
   ext_modules=cythonize(
       ext_modules,
       compiler_directives={"language_level": "3"}
   ),
   zip_safe=False,
)
