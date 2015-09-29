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
    """Main class in geosPy application that will act as a wrapper for models"""
    # public list that contains all available models (imported above)
    cdef public object models 
    cdef public object model
    cdef object _model

    def __init__(self, model = None):
        """Initializer for GeosPy main class"""
        # finding imported 
        class_members = inspect.getmembers(sys.modules[__name__], inspect.isclass)
        self.models = self._get_models(class_members, len(class_members))
        # if a model has been passed in on initialization,
        if model: 
            # then attempt to set that model
            self.set_model(model)

    cpdef set_model(self, model):
        """set_model sets the model to be used by Geospy class"""
        # if the model is in models
        if model.lower() in self.models:
            # set the model string to model name
            self.model = model
            # and load the model through raw eval
            self._model = eval(self.model.title())()
        else:
            # else the user passed a model not loaded / failed to load - either way raise NameError
            raise NameError("Model '{0}' is not defined. \nAvailable model(s):\n {1}".format(model, self.models))

    cpdef public train(self, user_location_dict, user_friend_dict):
        """extended by models to allow for supervised/semi-supervised learning features"""
        return self._model_call('train', user_location_dict, user_friend_dict)

    cpdef public locate(self, user_location_dict, user_friend_dict):
        """extended by models to locate users given a full user dict and friend dict of freezedsets"""
        # freezed sets because relationships do not change
        return self._model_call('locate', user_location_dict, user_friend_dict)

    # this is called "badass polymorphism"...
    cdef object _model_call(self, object function, object user_location_dict, object user_friend_dict):
        # if the model has not been set
        if self._model is None:
            # raise UnboundLocalError with description,
            raise UnboundLocalError("A model has not been selected")
        # if the model does not have the attribute error 
        elif not hasattr(self._model, function):
            # raise attribute error with description on the attribute not available
            raise AttributeError("The selected model does not extend {0}".format(function))
        else:
            # otherwise we call the function on the instantiated model
            return getattr(self._model, function)(user_location_dict, user_friend_dict)

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
        return [str(models[i], 'UTF-8').lower() for i in range(new_list_length-1)]
