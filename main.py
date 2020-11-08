import os
from pyaacrl import pyaacrl_cy as pyaacrl


# TODO: other test stand is probably worth implementing
songs_dir = "/home/maqquettex/projects/yaacrl/songs/"

songs_to_upload = []
songs_to_test = []

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
