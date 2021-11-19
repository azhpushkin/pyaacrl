# cython: c_string_type=unicode, c_string_encoding=utf8
# distutils: language = c++

# Cython cimports
from cython.operator cimport dereference as deref
from libcpp.string cimport string
from libcpp.memory cimport unique_ptr, make_unique
from libcpp.map cimport map

from lib cimport *

# Usuall Python imports
import logging

logger = logging.getLogger('pyaacrl')


cdef class Fingerprint:
    cdef unique_ptr[CppFingerprint] thisptr
    
    @staticmethod
    def from_wav(path):
        self = Fingerprint()
        self.thisptr = make_unique[CppFingerprint](CppWAVFile(path))
        return self

    @staticmethod
    def from_mp3(path):
        self = Fingerprint()
        self.thisptr = make_unique[CppFingerprint](CppMP3File(path))
        return self


cdef class StoredSong:
    cdef public int id
    cdef public string name

    def __init__(self, id, name):
        self.id = id
        self.name = name

    def __str__(self):
        return 'asd'


cdef StoredSong stored_song_from_cpp(CppStoredSong cpp_song):
    return StoredSong(id=cpp_song.id, name=cpp_song.name)


cdef class Storage:
    cdef unique_ptr[CppStorage] thisptr

    def __cinit__(self, dbfile: str):
        self.thisptr.reset(new CppStorage(dbfile))

    def store_fingerprint(self, fp: Fingerprint, name: str):
        return stored_song_from_cpp(
            deref(self.thisptr).store_fingerprint(deref(fp.thisptr), name)
        )

    def get_matches(self, fp: Fingerprint):
        cpp_results = deref(self.thisptr).get_matches(deref(fp.thisptr))
        
        results = []

        for i in range(cpp_results.size()):
            results.append((
                stored_song_from_cpp(cpp_results[i].first),
                cpp_results[i].second
            ))
        
        return results

    def list_songs(self):
        cpp_results = deref(self.thisptr).list_songs()
        return [stored_song_from_cpp(song) for song in cpp_results]


cdef void _custom_logger(CppLogLevel cpp_level, string log_msg):
    # read more about this at: http://docs.cython.org/en/latest/src/userguide/language_basics.html#error-return-values
    # in short, as _custom_logger has void return value, there are issues with passing
    # exception (if one happens) through the call stack
    try:
        if   cpp_level == Cpp_DEBUG:   logger.debug(log_msg)
        elif cpp_level == Cpp_INFO:    logger.info(log_msg)
        elif cpp_level == Cpp_WARNING: logger.warning(log_msg)
        elif cpp_level == Cpp_ERROR:   logger.error(log_msg)
    except KeyboardInterrupt:
        print('Exiting...')
        exit(0)
    except:
        logger.exception("Error during logging")
    


set_logger(_custom_logger)
