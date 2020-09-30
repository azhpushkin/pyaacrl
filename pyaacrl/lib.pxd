# cython: c_string_type=unicode, c_string_encoding=utf8

from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.utility cimport pair

# cdef extern from "fingerprint.h":
#     cdef int HASH_SIZE "HASH_SIZE"

# cdef extern from "fingerprint.h":
#     cdef cppclass CppPeak pair[int, int]:
#         pass

# CppPeak = pair[int, int]
ctypedef pair[int, int] CppPeak

cdef extern from "lib.h":    

    cdef cppclass CppFingerprint "Fingerprint":
        string name
        vector[CppPeak] peaks

        @staticmethod
        CppFingerprint fromWAV(string path)

        @staticmethod
        CppFingerprint fromWAV(string path, string name)