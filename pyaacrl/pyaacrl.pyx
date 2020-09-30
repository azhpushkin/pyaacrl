# cython: c_string_type=unicode, c_string_encoding=utf8

from cython.operator cimport dereference as deref, preincrement as inc
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.utility cimport pair
from libcpp.memory cimport unique_ptr, make_unique

from lib cimport CppFingerprint, CppPeak, CppHash, HashArray, HASH_SIZE



cdef class Fingerprint:
    cdef unique_ptr[CppFingerprint] thisptr
    cdef public string path

    def __init__(self, path: str, name: str):
        self.thisptr = make_unique[CppFingerprint](CppFingerprint.fromWAV(path, name))
        self.path = deref(self.thisptr).name

    def print_peaks(self):
        cdef vector[CppPeak] v = deref(self.thisptr).peaks
        cdef vector[CppPeak].iterator it = v.begin()

        while it != v.end():
            print((deref(it)).first, (deref(it)).second)
            inc(it)

    def print_hashes(self):
        cdef vector[CppHash] v = deref(self.thisptr).hashes
        cdef vector[CppHash].iterator it = v.begin()

        cdef HashArray x
        while it != v.end():
            x = (deref(it)).first
            print(<bytes>(x.data()[:HASH_SIZE]))  # make sure length is not overwhelmed
            inc(it)
            


        