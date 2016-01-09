GeosPy: Geolocation Inference Made Easy
=======================================

GeosPy is a MIT Licensed Geolocation Inference Library, written in Python.

Of the few existing Python modules for conducting geolocation inference,
most are verbose and cumbersome.

.. code-block:: python

    >>> from GeosPy import Geos
    >>> geosPy = Geos()
    >>> print geosPy.models
    ['jakartr', 'backstrom']
    >>> geosPy = geosPy.set_model('backstrom')
    >>> print geosPy.locate(user_location_dict, user_friend_dict)
    (45.5064721, -73.5768498)
    ...

GeosPy allows you to locate users with unknown locations based solely on
network-based relationships with the method of your choice. Network-based
geolocation inference can be 25% or more effective in locating users
than standard IP-address based inference.


Features
--------

- Python3.3, 3.4 and 3.5 Support
- Highly optimized Cython code
- Full unittest code coverage
- Multiple methods


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
#. Send a pull request and bug the maintainer until it gets merged and published. Make sure to add yourself to AUTHORS_.

.. `the repository`_: http://github.com/tylfin/GeosPy
.. AUTHORS_: https://github.com/tylfin/GeosPy/blob/master/AUTHORS
