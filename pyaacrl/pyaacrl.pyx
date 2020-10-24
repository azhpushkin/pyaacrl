# cython: c_string_type=unicode, c_string_encoding=utf8
# cython: language_level=3

from cython.operator cimport dereference as deref, preincrement as inc
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.utility cimport pair
from libcpp.memory cimport unique_ptr, make_unique
from libcpp.map cimport map

from lib cimport (
    CppWAVFile,
    CppFingerprint,
    CppStorage,
    CppPeak,
    CppHash,
    HashArray,
    HASH_SIZE
)

cdef class Fingerprint:
    cdef unique_ptr[CppFingerprint] thisptr
    cdef public string path

    def __init__(self, path: str, name: str = None):
        # unique_ptr passes params to constructor
        # Funny that stack allocation of C++ is not allowed, but it works here
        if name:
            self.thisptr = make_unique[CppFingerprint](CppWAVFile(path, name))
        else:
            self.thisptr = make_unique[CppFingerprint](CppWAVFile(path))

        self.path = deref(self.thisptr).name

    def yield_peaks(self):
        cdef vector[CppPeak] peaks = deref(self.thisptr).peaks

        cdef CppPeak peak
        for peak in peaks:
            yield (peak.first, peak.second)


    def yield_hashes(self):
        cdef vector[CppHash] hashes = deref(self.thisptr).hashes
        cdef CppHash hash

        cdef HashArray x
        for hash in hashes:
            yield (<bytes>(hash.first.data()[:HASH_SIZE]))
            

cdef class Storage:
    cdef unique_ptr[CppStorage] thisptr

    def __init__(self):
        self.thisptr.reset(new CppStorage())

    def store_fingerprint(self, fp: Fingerprint):
        deref(self.thisptr).store_fingerprint(deref(fp.thisptr))

    def get_matches(self, fp: Fingerprint):
        cdef map[string, float] matches
        matches = deref(self.thisptr).get_matches(deref(fp.thisptr))

        cdef map[string,float].iterator it = matches.begin()
        py_matches = {}
        while(it != matches.end()):
            py_matches[deref(it).first] = deref(it).second
            inc(it)
        
        return py_matches

        
