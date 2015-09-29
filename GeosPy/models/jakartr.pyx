"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# Cythonized Asset object.
cimport cython

cdef class Jakartr:
    """
    Jakartr is one of the most tweeted from locations, 
    making it a natural base model to use for testing
    """
    # private constant Jakartr's latitude and longitude
    cdef tuple JAKARTA_LAT_LON 

    def __cinit__(self):
        """C initialization"""
        self.JAKARTA_LAT_LON = (-6.2000, 106.8)

    cpdef public locate(self, object user_location_dict, object user_friend_dict):
        """returns the approximate location for users without locations"""
        for userId, location in user_location_dict.items():
            if not location:
                user_location_dict[userId] = self.JAKARTA_LAT_LON

        return user_location_dict

