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

    @property
    def name(self):
        return deref(self.thisptr).name

    @name.setter
    def name(self, new_name):
        deref(self.thisptr).name = new_name
            


cdef class Storage:
    cdef unique_ptr[CppStorage] thisptr

    def __cinit__(self, dbfile: str):
        self.thisptr.reset(new CppStorage(dbfile))

    def store_fingerprint(self, fp: Fingerprint):
        deref(self.thisptr).store_fingerprint(deref(fp.thisptr))

    def get_matches(self, fp: Fingerprint):
        return deref(self.thisptr).get_matches(deref(fp.thisptr))

cdef void _custom_logger(CppLogLevel cpp_level, string log_msg):
    if   cpp_level == Cpp_DEBUG:   logger.debug(log_msg)
    elif cpp_level == Cpp_INFO:    logger.info(log_msg)
    elif cpp_level == Cpp_WARNING: logger.warning(log_msg)
    elif cpp_level == Cpp_ERROR:   logger.error(log_msg)


set_logger(_custom_logger)
