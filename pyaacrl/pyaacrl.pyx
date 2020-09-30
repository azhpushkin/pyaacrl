# cython: c_string_type=unicode, c_string_encoding=utf8

from cython.operator cimport dereference as deref
from libcpp.string cimport string
from libcpp.memory cimport unique_ptr, make_unique

from lib cimport CppFingerprint



cdef class Fingerprint:
    cdef unique_ptr[CppFingerprint] thisptr
    cdef public string path

    def __init__(self, path: str, name: str):
        self.thisptr = make_unique[CppFingerprint](CppFingerprint.fromWAV(path, name))
        self.path = deref(self.thisptr).name

        