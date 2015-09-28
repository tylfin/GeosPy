"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# Cythonized Asset object.
cimport cython

cdef class Jakartr:
    cdef public object test 
    def __cinit__(self):
        None

    def __init__(self):
        print("hello world!")