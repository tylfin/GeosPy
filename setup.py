"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# Setup config from http://docs.cython.org
from distutils.extension import Extension
from distutils.core import setup
# Import Cython
from Cython.Build import cythonize
# Import numpy
import numpy as np

# extensions to compile
extensions=[
    Extension("GeosPy/utilities/*.pyx",
        ["GeosPy/utilities/*.pyx"],
        include_dirs=[np.get_include()],
        extra_compile_args=["-w"]),
    Extension("GeosPy/models/*.pyx",
        ["GeosPy/models/*.pyx"],
        include_dirs=[np.get_include()],
        extra_compile_args=["-w"]),
    Extension("GeosPy/*.pyx",
        ["GeosPy/*.pyx"],
        include_dirs=[np.get_include()],
        extra_compile_args=["-w"])
    ]

# full config
config = {
    'description': 'GeosPy',
    'author': 'Tyler Finethy',
    'url': 'https://github.com/tylfin/GeosPy',
    'download_url': 'https://github.com/tylfin/GeosPy',
    'author_email': 'tylfin@gmail.com',
    'version': '0.1',
    'packages': ['GeosPy', 'GeosPy.utilities', 'GeosPy.models'],
    'scripts': [],
    'name': 'GeosPy',
    'ext_modules':cythonize(extensions)
}

# setting up
setup(**config)
