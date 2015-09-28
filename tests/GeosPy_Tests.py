"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# import the unittest class that TestGeosPy will inherit
import unittest
# import the main class
from GeosPy import Geospy

class TestGeosPy(unittest.TestCase):
    def setUp(self):
        """setUp creates the class instance of GeosPy"""
        self.geospy = Geospy

    def test_fail_init_display_models(self):
        """ensuring error handling on passing a model that doesn't exist"""
        with self.assertRaises(NameError):
            elf.geospy("fail")

    def test_should_display_jakartr(self):
        """ensuring Jakartr, the test class is available"""
        self.assertTrue('Jakartr' in self.geospy().models)