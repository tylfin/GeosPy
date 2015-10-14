"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# Cythonized Asset object.
cimport cython
# C math library, importing natural log
from libc.math cimport log, sin, cos, acos
from libc.math cimport abs as ABS
from libc.math cimport pow as POW
from GeosPy.utilities.distance cimport distance

cdef class Backstrom:
    """
    Backstrom implementation based on: "Find me if you can: improving geographical
    prediction with social and spatial proximity"

    See link to paper for more details:
    http://dl.acm.org/citation.cfm?id=1772698
    """
    # cdef tuple FOOBAR
    cdef inline float A, B, C

    def __cinit__(self):
        """C initialization"""
        self.A = 0.0019
        self.B = 0.196
        self.C = -0.015

    cpdef public locate(self, object user_location_dict, object user_friend_dict):
        """returns the approximate location for users without locations"""
        return self._run(user_location_dict, user_friend_dict)

    cpdef public train(self, object user_location_dict, object user_friend_dict):
        """trains the backstrom method to overwrite default constants from paper"""
        return None

    cdef inline object _run(self, object user_location_dict, object user_friend_dict):
        for user, location in user_location_dict.items():
            # don't need to approximate the location of users with known location,
            # can't approximate the user without any conditional knowledge
            # TODO: set users not in user_friend_dict to average location of previously known users (best guess given dataset)
            if location or user not in user_friend_dict: continue
            maximum_likelihood = None
            neighbors = user_friend_dict[user]
            for neighbor_u in neighbors:
                # we can ignore friends not in the user_location_dict, or friends without locations
                if neighbor_u not in user_location_dict or not user_location_dict[neighbor_u]: continue
                # find the location of neighbor_u
                nb_u_loc = user_location_dict[neighbor_u]
                # we initially set the best_approximate location to the first found neighbor with a location
                if user_location_dict[user] is None:
                    user_location_dict[user] = nb_u_loc
                # (re)set total likelihood per neighbor_u
                total_likelihood = 0.0
                # loop through the neighbors of the user
                for neighbor_v in neighbors:
                    # same as for nb_u
                    if neighbor_v is neighbor_u or neighbor_v not in user_location_dict or not user_location_dict[neighbor_v]:
                        continue
                    # same as for nb_u
                    nb_v_loc = user_location_dict[neighbor_v]
                    probability = self._calculate_probability(nb_u_loc, nb_v_loc)
                    likelihood = log(probability) - log(1-probability)
                    # sum over the likelihood probabilities
                    total_likelihood += (likelihood)
                # check if greater than maximum likelihood
                if maximum_likelihood is None or total_likelihood > maximum_likelihood:
                    maximum_likelihood = total_likelihood
                    user_location_dict[user] = nb_u_loc
        # return the user_location_dict with new locations
        return user_location_dict

    cdef inline _calculate_probability(self, nb_u_loc, nb_v_loc):
        return self.A * POW(ABS(distance(nb_u_loc[0], nb_u_loc[1], nb_v_loc[0], nb_v_loc[1]) + self.B), self.C)
