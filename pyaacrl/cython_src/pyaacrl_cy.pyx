# cython: c_string_type=unicode, c_string_encoding=utf8
# cython: language_level=3

from cython.operator cimport dereference as deref
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.memory cimport unique_ptr, make_unique
from libcpp.map cimport map

from lib cimport (
    CppWAVFile,
    CppMP3File,
    CppFingerprint,
    CppStorage,
    CppPeak,
    CppHash,
    HASH_SIZE
)


cdef class Fingerprint:
    cdef unique_ptr[CppFingerprint] thisptr
    
    @staticmethod
    def from_wav(path, name = None):
        self = Fingerprint()
        if name:
            self.thisptr = make_unique[CppFingerprint](CppWAVFile(path, name))
        else:
            self.thisptr = make_unique[CppFingerprint](CppWAVFile(path))
        
        return self

    @staticmethod
    def from_mp3(path, name = None):
        self = Fingerprint()
        if name:
            self.thisptr = make_unique[CppFingerprint](CppMP3File(path, name))
        else:
            self.thisptr = make_unique[CppFingerprint](CppMP3File(path))
        
        return self
    

    def yield_peaks(self):
        cdef vector[CppPeak] peaks = deref(self.thisptr).peaks

        cdef CppPeak peak
        for peak in peaks:
            yield (peak.window, peak.bin)


    def yield_hashes(self):
        cdef vector[CppHash] hashes = deref(self.thisptr).hashes
        cdef CppHash hash

        for hash in hashes:
            yield (<bytes>(hash.hash.data()[:HASH_SIZE]))
            

cdef class Storage:
    cdef unique_ptr[CppStorage] thisptr

    def __cinit__(self, dbfile: str):
        self.thisptr.reset(new CppStorage(dbfile))

    def store_fingerprint(self, fp: Fingerprint):
        deref(self.thisptr).store_fingerprint(deref(fp.thisptr))

    def get_matches(self, fp: Fingerprint):
        cdef map[string, float] matches
        matches = deref(self.thisptr).get_matches(deref(fp.thisptr))

        return matches
