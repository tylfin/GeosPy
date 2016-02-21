"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# Cythonized Asset object.
cimport cython
# Model imports
from GeosPy.models import *

MODELS = frozenset(['backstrom', 'jakartr'])

cdef class Geos:
    """Main class in geosPy application that will act as a wrapper for models"""
    # public list that contains all available models (imported above)
    cdef readonly object models
    cdef readonly object model
    cdef inline object _model
    cdef object result

    def __init__(self, model = None):
        """Initializer for GeosPy main class"""
        # set models to hardcoded frozenset of available models
        self.models = MODELS
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
            # return the class with the initialized model
            return self
        else:
            # else the user passed a model not loaded / failed to load - either way raise NameError
            raise NameError("Model '{0}' is not defined. \nAvailable model(s):\n {1}".format(model, self.models))

    cpdef public train(self, user_location_dict, user_friend_dict):
        """extended by models to allow for supervised/semi-supervised learning features"""
        self._model = self._model_call('train', user_location_dict, user_friend_dict)
        return self

    cpdef public locate(self, user_location_dict, user_friend_dict):
        """extended by models to locate users given a full user dict and friend dict of freezedsets"""
        # freezed sets because relationships do not change
        return self._model_call('locate', user_location_dict, user_friend_dict)

    # this is called "badass polymorphism"...
    cdef inline object _model_call(self, object function, object user_location_dict, object user_friend_dict):
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
