# cython: c_string_type=unicode, c_string_encoding=utf8

from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.utility cimport pair
from libcpp.map cimport map

cdef extern from "fingerprint.h":
    cdef int HASH_SIZE "HASH_SIZE"

cdef extern from "<array>" namespace "std" nogil:
    cdef cppclass HashArray "std::array<char, HASH_SIZE>":
        const char* data();


ctypedef pair[int, int] CppPeak
ctypedef pair[HashArray, int] CppHash

cdef extern from "lib.h":    

    cdef cppclass CppFingerprint "Fingerprint":
        string name
        vector[CppPeak] peaks
        vector[CppHash] hashes

        @staticmethod
        CppFingerprint fromWAV(string path)

        @staticmethod
        CppFingerprint fromWAV(string path, string name)
    
    cdef cppclass CppStorage "Storage":
        CppStorage() except +

        void store_fingerprint(CppFingerprint f)
        map[string, float] get_matches(CppFingerprint f)