GeosPy: Geolocation Inference Made Easy
=======================================

.. image:: https://travis-ci.org/tylfin/GeosPy.svg?branch=master
    :target: https://travis-ci.org/tylfin/GeosPy

GeosPy is a MIT Licensed Geolocation Inference Library, written in Python.

Of the few existing Python modules for conducting geolocation inference,
most are verbose and cumbersome.

.. code-block:: python

    >>> from GeosPy import Geos
    >>> geosPy = Geos()
    >>> print(geosPy.models)
    frozenset({'jakartr', 'backstrom'})
    >>> geosPy = geosPy.set_model('backstrom')
    >>> user_location_dict = {'Tyler': (44, -71.5), 'Fake': None}
    >>> user_friend_dict = {'Fake':['Tyler']}
    >>> print(geosPy.locate(user_location_dict, user_friend_dict))
    {'Tyler': (44, -71.5), 'Fake': (44, -71.5)}
    ...

GeosPy is based off of `Jurgens et al. (2015)`_, implementing state-of-the-art
methods for geolocation inference. It allows the user to locate nodes with unknown locations
based solely on network-based relationships.


Features
--------

- State-of-the-art geolocation inference method(s)
- Supports python 3.3, 3.4 and 3.5
- Written in cython
- Test coverage


Installation
------------

To install GeosPy from source run the following commands

.. code-block:: bash

    > git clone https://github.com/tylfin/GeosPy/
    > cd GeosPy
    > pip install -r requirements.txt
    ...
    Successfully installed ...
    > make build_inplace
    ...
    > make test
    ...
    OK
    > make install
    ...
    
PIP support coming soon!
    
Documentation
-------------

The GeosPy library makes one wrapper class Geos available with three public methods:

 - set_model: sets the model to be used by GeosPy
    - takes as input the name of an available model, and outputs the instatiated class with model set
    - raises NameError if model not available
 - train: trains the model (optional in most cases) using the given data
    - takes as input a key to location (latitude, longitude) or None dictionary, a key to keys dictionary.
 - locate: runs the model, returning users approximate location
    - takes as input a key to location (latitude, longitude) or None dictionary, a key to keys dictionary, and outputs a dictionary run against the model.
    
That's it! 


Contribute
----------

#. Check for open issues or open a fresh issue to start a discussion around a feature idea or a bug.
#. Fork `the repository`_ on GitHub to start making your changes to the **master** branch (or branch off of it).
#. Write a test which shows that the bug was fixed or that the feature works as expected.
#. Send a pull request and bug the maintainer until it gets merged and published. Make sure to add yourself to `AUTHORS`_.

.. _the repository: http://github.com/tylfin/GeosPy
.. _AUTHORS: https://github.com/tylfin/GeosPy/blob/master/AUTHORS
.. _Jurgens et al. (2015): http://www-cs.stanford.edu/~jurgens/docs/jurgens-et-al_icwsm-2015.pdf
.. _clone the repository: https://help.github.com/articles/cloning-a-repository/
