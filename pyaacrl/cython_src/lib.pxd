from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.utility cimport pair
from libcpp.map cimport map

# NOTE: this .pxd does not define all the fields and methods,
#       but only the ones that are user from the Cython code.
# This makes our life much easier :D

cdef extern from "yaacrl/yaacrl.h" namespace "yaacrl":
    cdef cppclass CppWAVFile "yaacrl::WAVFile":
        string name
        CppWAVFile (string path)

    cdef cppclass CppMP3File "yaacrl::MP3File":
        string name
        CppMP3File (string path)

    cdef cppclass CppFingerprint "yaacrl::Fingerprint":
        CppFingerprint(CppWAVFile file)

    cdef cppclass CppStoredSong "yaacrl::StoredSong":
        int id
        string name
    
    cdef cppclass CppStorage "yaacrl::Storage":
        CppStorage(string)

        CppStoredSong store_fingerprint(CppFingerprint f, string name)
        void delete_stored_song(CppStoredSong)
        CppStoredSong rename_stored_song(CppStoredSong s, string new_name)
        vector[CppStoredSong] list_songs()

        vector[pair[CppStoredSong, float]] get_matches(CppFingerprint f)


cdef extern from "yaacrl/config.h" namespace "yaacrl":
    # wrapping `enum class`
    cdef enum CppLogLevel "yaacrl::LogLevel":
        Cpp_DEBUG "yaacrl::LogLevel::DEBUG"
        Cpp_INFO "yaacrl::LogLevel::INFO"
        Cpp_WARNING "yaacrl::LogLevel::WARNING"
        Cpp_ERROR "yaacrl::LogLevel::ERROR"


    cdef void set_logger(void(*)(CppLogLevel, string))