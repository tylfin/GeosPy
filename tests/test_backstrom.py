"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# import the unittest class that TestGeosPy will inherit
import unittest
# import the main class
from GeosPy import Geos
from GeosPy.models import backstrom

class TestBackstrom(unittest.TestCase):
    def setUp(self):
        """setUp creates the class instance of GeosPy"""
        self.geospy = Geos

    def test_should_have_model_backstrom(self):
        """ensuring Backstrom, the test class is available"""
        self.assertTrue('backstrom' in self.geospy().models)

    def test_backstrom_should_be_set_from_init(self):
        model = 'backstrom'
        self.geospy = self.geospy(model)
        self.assertTrue(isinstance(self.geospy, Geos))
        self.assertEqual(self.geospy.model, model)

    def test_backstrom_should_be_set_from_method(self):
        model = 'backstrom'
        self.geospy = self.geospy().set_model(model)
        self.assertTrue(isinstance(self.geospy, Geos))
        self.assertEqual(self.geospy.model, model)

    def test_backstrom_locate_function(self):
        """testing locate function for Backstrom model"""
        user_location_dict = {'1': (0,0), '2': None, '3':(1,1), '4':(0,0),
            '5':(0,0), '6':(0,0), '7':(0,0)}
        user_friend_dict = {'1': frozenset(['2','3']),
            '2': frozenset(['1','3','4','5','6','7']),
            '3':frozenset(['1','3','6']) }
        output = self.geospy('backstrom').locate(user_location_dict, user_friend_dict)
        self.assertEqual(output['2'], (0,0))

    def test_backstrom_location_function_using_set_model(self):
        """testing locate function for Backstrom model using set model"""
        user_location_dict = {'1': (0,0), '2': None, '3':(1,1), '4':(0,0),
            '5':(0,0), '6':(0,0), '7':(0,0)}
        user_friend_dict = {'1': frozenset(['2','3']),
            '2': frozenset(['1','3','4','5','6','7']),
            '3':frozenset(['1','3','6']) }
        self.geospy = self.geospy().set_model('backstrom')
        output = self.geospy.locate(user_location_dict, user_friend_dict)
        self.assertEqual(output['2'], (0,0))

    def test_backstrom_train_function(self):
        """testing locate function for Backstrom model using set model"""
        user_location_dict = {'1': (0,0), '2': None, '3':(1,1), '4':(0,0),
            '5':(0,0), '6':(0,0), '7':(0,0)}
        user_friend_dict = {'1': frozenset(['2','3']),
            '2': frozenset(['1','3','4','5','6','7']),
            '3':frozenset(['1','3','6'])}
        self.geospy = self.geospy().set_model('backstrom')
        output = self.geospy.train(user_location_dict, user_friend_dict)
        print(output)
        # self.assertEqual(output['2'], (0,0))

    def test_backstrom_train_throw_error(self):
        """testing train function to throw error when no location data available"""
        self.geospy = self.geospy().set_model('backstrom')
        with self.assertRaises(ValueError):
            self.geospy.train({},{})
