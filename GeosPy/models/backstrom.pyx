"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
# Cythonized Asset object.
cimport cython
# C math library, importing natural log
from libc.math cimport log, sin, cos, acos
from libc.math cimport abs as cabs
from libc.math cimport pow as cpow
from libc.math cimport round as cround
# cimport GeosPy.utilities.levmarq
from GeosPy.utilities.distance cimport distance
# python packages
from collections import defaultdict
# from scipy.optimize import curve_fit
import numpy as np

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
        return self._train(user_location_dict, user_friend_dict)

    cdef inline object _run(self, object user_location_dict, object user_friend_dict):
        """
        _run iterates over all users, performing the Backstrom method on users
        with unknown locations
        """
        for user, location in user_location_dict.items():
            # don't need to approximate the location of users with known
            # location, can't approximate the user without any conditional
            # knowledge
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

    cdef inline object _train(self, object node_location_dict,
        object node_relationship_dict):
        """
        _train computes new coefficients for the Backstrom method based on
        Probability of friendship as a function of distance.

        By computing the number of pairs of individuals at varying distances,
        along with the number of friends at those distances,
        we are able to compute the probability of two people at distance d knowing each other.
        We see here that it is a reasonably good fit to a power-law with exponent near 1.
        """
        # compute the size of users with location
        nodes_with_location = [node_with_location for node_with_location,
            node_location in node_location_dict.items() if node_location]
        # precompute the normalized additive amount
        size = len(nodes_with_location)
        # raise an error if there are no nodes with location data
        if size == 0: raise ValueError("No location information passed!")
        # smoothing additive
        additive = (1.0/size)
        bucketed_distances = defaultdict(float)
        # for each node with a location
        for node in nodes_with_location:
          if node not in node_relationship_dict:
            continue
          # grab its location
          node_location = node_location_dict[node]
          # for each neighbor
          for neighbor_node in node_relationship_dict[node]:
            if neighbor_node not in node_location_dict:
                continue
            neighbor_location = node_location_dict[neighbor_node]
            if not neighbor_location: continue
            # unpack the locations
            u_lat, u_lon = node_location
            v_lat, v_lon = neighbor_location
            node_neighbor_distance = distance(u_lat, u_lon, v_lat, v_lon)
            # Backstrom et al. bucket the distances in 1/10 mile increments
            bucketed_distance = round(node_neighbor_distance, 1)
            # add the bucketed distance to the bucketed distances dictionary
            # to keep track # of friends at what distances
            bucketed_distances[bucketed_distance] += additive

        _distances = np.array([_distance for _distance in bucketed_distances.items()])
        _locations = np.array([_location for _location in bucketed_distances.items()])

        # curve_fit(self._test_function_to_fit, _distances, _locations)
        return

    def _test_function_to_fit(self, x, a, b, c):
      """wrapper function for calculate probability"""
      return self._function_to_fit(x, a, b, c)

    cdef inline float _function_to_fit(self, float x, float a, float b, float c):
      """Function as defined in backstrom, three DOE to fit"""
      return a * cpow((x + b), c)

    def _test_calculate_probability(self, nb_u_loc, nb_v_loc):
      """wrapper function for test probability """
      return self._calculate_probability(nb_u_loc, nb_v_loc)

    cdef inline _calculate_probability(self, nb_u_loc, nb_v_loc):
      """
      Probability function from Backstrom

      For each neighbor nb_v of nb_u whose location nb_v_loc is known, we can
      compute the probability of the edge being present given the
      distance between u and v
      """
      return self.A * cpow(cabs(distance(nb_u_loc[0], nb_u_loc[1], nb_v_loc[0], nb_v_loc[1]) + self.B), self.C)
