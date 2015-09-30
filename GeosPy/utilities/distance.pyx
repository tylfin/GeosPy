"""
  Copyright (c) 2015, Tyler Finethy

  All rights reserved. See LICENSE file for details
"""
from libc.math cimport log, sin, cos, acos

cdef inline float PI = 3.14159265358979323846
# degree to radian converter
cdef inline double deg2rad(double deg):
    return (deg * PI / 180)
# radian to degree converter
cdef inline double rad2deg(double rad):
    return (rad * 180 / PI);
# simple latitude distance calculator
cdef inline double distance(double lat1, double lon1, double lat2, double lon2):
    cdef double theta, dist
    theta = lon1 - lon2;
    dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta))
    dist = acos(dist)
    dist = rad2deg(dist)
    return (dist * 60 * 1.1515)