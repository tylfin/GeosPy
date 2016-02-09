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

- Python3.3, 3.4 and 3.5 Support
- Highly optimized cython code
- State-of-the-art methods
- Code coverage


Installation
------------

TODO


Documentation
-------------

TODO


Contribute
----------

#. Check for open issues or open a fresh issue to start a discussion around a feature idea or a bug.
#. Fork `the repository`_ on GitHub to start making your changes to the **master** branch (or branch off of it).
#. Write a test which shows that the bug was fixed or that the feature works as expected.
#. Send a pull request and bug the maintainer until it gets merged and published. Make sure to add yourself to `AUTHORS`_.

.. _the repository: http://github.com/tylfin/GeosPy
.. _AUTHORS: https://github.com/tylfin/GeosPy/blob/master/AUTHORS
.. _Jurgens et al. (2015): http://www-cs.stanford.edu/~jurgens/docs/jurgens-et-al_icwsm-2015.pdf
