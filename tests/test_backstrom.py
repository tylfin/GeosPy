"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# import the unittest class that TestGeosPy will inherit
import unittest
# import the main class
from GeosPy import Geos

class TestBackstrom(unittest.TestCase):
    def setUp(self):
        """setUp creates the class instance of GeosPy"""
        self.geospy = Geos

    def test_should_have_model_backstrom(self):
        """ensuring Jakartr, the test class is available"""
        self.assertTrue('backstrom' in self.geospy().models)

    def test_backstrom_locate_function(self):
        """testing locate function for jakartr model"""
        user_location_dict = {'1': (0,0), '2': None, '3':(1,1), '4':(0,0), '5':(0,0), '6':(0,0), '7':(0,0)}
        user_friend_dict = {'1': frozenset(['2','3']), '2': frozenset(['1','3','4','5','6','7']), '3':frozenset(['1','3','6']) }
        output = self.geospy('backstrom').locate(user_location_dict, user_friend_dict)
        self.assertEqual(output['2'], (0,0))
