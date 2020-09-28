from libcpp.string cimport string
# from libcpp.vector cimport vector

cdef extern from "lib.hpp":
    cdef cppclass CppFingerprint "Fingerprint":
        string name

        static Fingerprint fromWAV(string path);
        static Fingerprint fromWAV(string path, string name);
        