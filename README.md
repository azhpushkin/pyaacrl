## pyaacrl - Python Yet Another Audio Recognition Library 

This is wrapper around [yaacrl](https://github.com/azhpushkin/yaacrl) C++ library,
implemented with Cython and scikit-build. Check out README of `yaacrl` for
more details of the project.

Also make sure to check
[pyaacrl-demo](https://github.com/azhpushkin/pyaacrl-demo), which is GUI
to demostrate usage and features of this wrapper (and C++ library as well).


### Trying it out

To try this one out, you have several options:
* `pyaacrl-demo` - simplest one to try
* `pip install git+https://github.com/azhpushkin/pyaacrl`
* clone the repository and build manually. Check out `makefile` to see how it works.

There is also `main.py` test program, that can perform both fingerprinting and
matching of audio:

```bash
# library.db will be created if not exists
$ python main.py fingerprint library.sqlite /path/to/folder/with/songs
[INFO] SQLite database setup completed successfully
Starting..
[DEBUG] Loaded WAVFile: /path/to/folder/with/songs/song-1.wav
[INFO] Fingeprints generated for /path/to/folder/with/songs/song-1.wav
[INFO] Successfully stored /path/to/folder/with/songs/song-1.wav
[DEBUG] Loaded MP3File: /path/to/folder/with/songs/song-2.mp3
[INFO] Fingeprints generated for /path/to/folder/with/songs/song-2.mp3
[INFO] Successfully stored /path/to/folder/with/songs/song-2.mp3
Total songs in DB now: 4

# Now perform matching
$ python main.py match library.sqlite /path/to/audio.mp3
[INFO] SQLite database setup completed successfully
[DEBUG] Loaded MP3File: /path/to/audio.mp3
[INFO] Fingeprints generated for /path/to/audio.mp3
[INFO] Matches lookup processed
Matches: 
  -> audio.mp3: 42.72 %
```

This test program is mirroring `yaacrl` C++ test program.


### TODOs
- [ ] mypy stubs
- [ ] test out how multiprocessing works
- [ ] tests and GitHub actions?

