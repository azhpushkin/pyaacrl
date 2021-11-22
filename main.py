import os
import pyaacrl
import logging
import sys


pyaacrl.logger.setLevel(logging.DEBUG)
f = logging.StreamHandler(sys.stdout)
f.setFormatter(logging.Formatter('[%(levelname)s] %(message)s'))
pyaacrl.logger.addHandler(f)


def fingerprint(library_path, songs_dir):
    storage = pyaacrl.Storage(library_path)

    for s in os.listdir(songs_dir):
        full_path = os.path.join(songs_dir, s)
        if s.endswith('.wav'):
            storage.store_fingerprint(pyaacrl.Fingerprint.from_wav(full_path), s)
        elif s.endswith('.mp3'):
            storage.store_fingerprint(pyaacrl.Fingerprint.from_mp3(full_path), s)
        else:
            print('Unknown file format:', s)
    
    print('Total songs in DB now:', len(storage.list_songs()))


def match(library_path, clip_path):
    storage = pyaacrl.Storage(library_path)

    if clip_path.endswith('.wav'):
        matches = storage.get_matches(pyaacrl.Fingerprint.from_wav(clip_path))
    elif clip_path.endswith('.mp3'):
        matches = storage.get_matches(pyaacrl.Fingerprint.from_mp3(clip_path))
    else:
        print('Unknown file format:', clip_path)
        return
    
    print('Matches: ')
    for song, confidence in matches:
        song: pyaacrl.StoredSong
        print(f'  -> {song.name}: {confidence*100:.4} %')


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print(
            'Please use following format: python main.py operation_type library_path object_path\n'
            '  operation_type: fingerprint OR match\n'
            '  library_path: path to library for storing or matching\n'
            '  object_path: folder to fingerprint OR audio file to match\n'
        )
    
    _, operation, library_path, obj_path = sys.argv
    if operation == 'fingerprint':
        fingerprint(library_path, obj_path)
    elif operation == 'match':
        match(library_path, obj_path)
    else:
        print('Unknown operation', operation)
