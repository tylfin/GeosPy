"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# import the unittest class that TestUtilities will inherit
import cython
import unittest
# import the distance function
from GeosPy.utilities import distance

class TestUtilities(unittest.TestCase):
    def setUp(self):
        # placeholder if necessary in the future
        pass

    def test_distance_function_properly_computes_distance_in_miles(self):
        # creating the test-points
        lat1, lon1 = 0, 0
        lat2, lon2 = 1, 1
        # externally calculated approx distance in miles
        approx_dist = 97.68
        # assert almost equal, inherent uncertainty in approximate
        # methods, this implementation is "good enough," due to speed concerns
        self.assertAlmostEqual(distance.distance_test(lat1, lon1, lat2, lon2),
            approx_dist, delta=.1)

    def test_distance_function_properly_computes_distance_in_miles_for_long_distances(self):
        # creating the test-points
        lat1, lon1 = (35.5800, -82.5558)
        lat2, lon2 = (35.0117, 135.7683)
        # externally calculated approx distance in miles
        approx_dist = 6984
        self.assertAlmostEqual(distance.distance_test(lat1, lon1, lat2, lon2),
            approx_dist, delta=15)
