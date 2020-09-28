from cython.operator cimport dereference as deref
from libcpp.string cimport string
from libcpp.memory cimport unique_ptr, make_unique

cdef extern from "lib.h":
    cdef cppclass CppFingerprint "Fingerprint":
        string name

        @staticmethod
        CppFingerprint fromWAV(string path)

        @staticmethod
        CppFingerprint fromWAV(string path, string name)


cdef class Fingerprint:
    cdef unique_ptr[CppFingerprint] thisptr
    cdef public string path

    def __init__(self, path: str, name: str):
        self.thisptr = make_unique[CppFingerprint](CppFingerprint.fromWAV(path, name))
        self.path = deref(self.thisptr).name

        