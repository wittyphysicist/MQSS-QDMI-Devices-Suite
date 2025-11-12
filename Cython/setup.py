from setuptools import setup
from Cython.Build import cythonize

setup(
    name="qaptiva_cython",
    ext_modules=cythonize(
        "qaptiva_cython.pyx",
        compiler_directives={
            "language_level": "3",  # Use Python 3 syntax
            "boundscheck": False,   # Optional speed-up
            "wraparound": False,    # Optional speed-up
        },
    ),
    zip_safe=False,
)
