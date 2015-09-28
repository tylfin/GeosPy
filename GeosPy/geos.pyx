"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# Cythonized Asset object.
cimport cython
# Cython imports
from cpython cimport array
from libc.stdlib cimport malloc, free
# System imports
import sys, inspect
# Model imports
from GeosPy.models import *

cdef class Geospy:
    # public list that contains all available models (imported above)
    cdef public object models 

    def __init__(self, model = None):
        """Initializer for GeosPy main class"""
        # finding imported 
        class_members = inspect.getmembers(sys.modules[__name__], inspect.isclass)
        self.models = self._get_models(class_members, len(class_members))
        # if a model has been passed in on initialization,
        if model: 
            # then attempt to set that model
            self.set_model(model)

    def set_model(self, model):
        """set_model sets the model to be used by Geospy class"""
        # if the model is in models
        if model in self.models:
            # set the model string to model name
            self.model = model
            # and load the model through raw eval
            self._model = eval(self.model)
        else:
            # else the user passed a model not loaded / failed to load - either way raise NameError
            raise NameError("Model '{0}' is not defined. \nAvailable model(s):\n {1}".format(model, self.models))

    cdef object _get_models(self, object class_members, int new_list_length):
        """_get_models is an internal function to find all imported models""" 
        # define integers position, and i for array manipulation,
        cdef int position, i
        # create c string for storing pythonic-strings in
        cdef char* c_string
        # create c array allocating enough memory for the names of all models
        cdef char **models = <char **>malloc(cython.sizeof(new_list_length - 1))
        # if the memory has not been properly allocated, raise a MemoryError
        if models is NULL:
            raise MemoryError()
        # position is the position in the models array that will be returned
        position = 0
        # i is the position in the class_members array that will be iterated over
        for i in range(new_list_length):
            if class_members[i][0] is not "Geospy":
                # tmp variable, need to encode string -> byte for safe storage in array 
                py_byte_string = class_members[i][0].encode('UTF-8')
                c_string = py_byte_string
                models[position] = c_string
                # increment the position counter only if an item is added to models
                position += 1
        # C-Array -> Python List conversion 
        return [str(models[i], 'UTF-8') for i in range(new_list_length-1)]
