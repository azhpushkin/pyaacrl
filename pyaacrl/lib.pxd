# cython: c_string_type=unicode, c_string_encoding=utf8

from libcpp.string cimport string

cdef extern from "lib.h":
    cdef cppclass CppFingerprint "Fingerprint":
        string name

        @staticmethod
        CppFingerprint fromWAV(string path)

        @staticmethod
        CppFingerprint fromWAV(string path, string name)