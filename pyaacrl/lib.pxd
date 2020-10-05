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

cdef extern from "lib.h" namespace "yaacrl":
    cdef cppclass CppWAVFile "yaacrl::WAVFile":
        CppWAVFile (string path)
        CppWAVFile (string path, string name)
    

    cdef cppclass CppFingerprint "yaacrl::Fingerprint":
        CppFingerprint(CppWAVFile file)
        string name
        vector[CppPeak] peaks
        vector[CppHash] hashes

    
    cdef cppclass CppStorage "yaacrl::Storage":
        CppStorage() except +

        void store_fingerprint(CppFingerprint f)
        map[string, float] get_matches(CppFingerprint f)