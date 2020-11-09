from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.map cimport map
from libc.stdint cimport uint8_t


# TODO: add helper struct to namespace
cdef extern from "yaacrl/yaacrl.h":
    cdef cppclass CppPeak "Peak":
        int window
        int bin

    cdef cppclass CppHash "Hash":
        uint8_t hash_data[16]
        int offset


cdef extern from "yaacrl/yaacrl.h" namespace "yaacrl":
    cdef cppclass CppWAVFile "yaacrl::WAVFile":
        string name
        CppWAVFile (string path)
        CppWAVFile (string path, string name)

    cdef cppclass CppMP3File "yaacrl::MP3File":
        string name
        CppMP3File (string path)
        CppMP3File (string path, string name)

    cdef cppclass CppFingerprint "yaacrl::Fingerprint":
        CppFingerprint(CppWAVFile file)
        string name
        vector[CppPeak] peaks
        vector[CppHash] hashes
    
    cdef cppclass CppStorage "yaacrl::Storage":
        CppStorage(string)

        void store_fingerprint(CppFingerprint f)
        map[string, float] get_matches(CppFingerprint f)