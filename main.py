import os
import pyaacrl
import logging
import sys


# TODO: other test stand is probably worth implementing
songs_dir = "../yaacrl/songs/"

songs_to_upload = []
songs_to_test = []


pyaacrl.logger.setLevel(logging.DEBUG)
f = logging.StreamHandler(sys.stdout)
f.setFormatter(logging.Formatter('[%(levelname)s] %(message)s'))
pyaacrl.logger.addHandler(f)

for s in os.listdir(songs_dir):
    if (not s.endswith('.wav')) or s.startswith('skip_'):
        continue

    if s.startswith('test_'):
        songs_to_test.append(songs_dir+s)
    else:
        songs_to_upload.append(songs_dir+s)

storage = pyaacrl.Storage("file.sqlite")

for s in songs_to_upload:
    print('### FINGERPRINTING: ', s)
    f = pyaacrl.Fingerprint.from_wav(s)
    storage.store_fingerprint(f)


for s in songs_to_test:
    print('Mathces for ', s)
    f = pyaacrl.Fingerprint.from_wav(s)
    matches = storage.get_matches(f)
    print('\t *', matches)
