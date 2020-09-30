import os
import pyaacrl

print(dir(pyaacrl))

# TODO: other test stand is probably worth implementing
songs_dir = "/home/maqquettex/projects/yaacrl/songs/"

first_wav_song = [s for s in os.listdir(songs_dir) if s.endswith('.wav')][0]
print('### FINGERPRINTING: ', first_wav_song)

f = pyaacrl.Fingerprint(songs_dir + first_wav_song, first_wav_song)
print(f)