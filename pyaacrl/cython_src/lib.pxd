from libcpp.string cimport string
from libcpp.map cimport map


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
    
    cdef cppclass CppStorage "yaacrl::Storage":
        CppStorage(string)

        void store_fingerprint(CppFingerprint f)
        map[string, float] get_matches(CppFingerprint f)


cdef extern from "yaacrl/config.h" namespace "yaacrl":
    # wrapping `enum class`
    cdef cppclass CppLogLevel "yaacrl::LogLevel":
        pass

    cdef CppLogLevel Cpp_DEBUG
    cdef CppLogLevel Cpp_INFO
    cdef CppLogLevel Cpp_WARNING
    cdef CppLogLevel Cpp_ERROR


    cdef void set_logger(void(*)(CppLogLevel, string))