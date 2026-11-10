# Caja musical de "Noche de paz" (F. X. Gruber, 1818 — dominio público), sintetizada.
# Salida: musica.wav (28 s, estéreo 44.1 kHz)
import numpy as np, wave, sys
SR = 44100; DUR = 42.0; E = 0.41          # duración de una corchea (6/8, ~49 bpm, de canción de cuna)
START = 0.35
N = lambda n: 440.0 * 2 ** ((n - 69) / 12)
C4,D4,E4,F4,G4,A4,B4,C5,D5,E5,F5 = 60,62,64,65,67,69,71,72,74,76,77
mel = [ (G4,3),(A4,1),(G4,2),(E4,6), (G4,3),(A4,1),(G4,2),(E4,6),
        (D5,4),(D5,2),(B4,6), (C5,4),(C5,2),(G4,6),
        (D5,4),(D5,2),(F5,3),(D5,1),(B4,2), (C5,6),(E5,6),
        (C5,3),(G4,1),(E4,2),(G4,3),(F4,1),(D4,2),(C4,12) ]
# acordes por compás (6 corcheas)
chords = ['C','C','C','C','G','G','C','C','G7','G7','C','C','C','G7','C','C']
CH = {'C':[48,55,60,64], 'G':[43,50,55,59], 'G7':[43,50,53,59]}
n = int(SR * DUR); L = np.zeros(n); Rr = np.zeros(n)

def box(freq, dur=2.6, amp=1.0):
    t = np.arange(int(SR * dur)) / SR
    parts = [(1, 1.0, 1.6), (2.0, .35, 3.0), (3.01, .18, 4.5), (4.2, .10, 7.0), (5.43, .05, 9.0)]
    s = sum(a * np.sin(2*np.pi*freq*r*t) * np.exp(-d*t) for r, a, d in parts)
    att = np.minimum(1, t / 0.004)
    return amp * s * att

def pad(freqs, dur, amp):
    t = np.arange(int(SR * dur)) / SR
    env = np.minimum(1, t/0.6) * np.minimum(1, (dur - t)/0.8).clip(0)
    s = sum(np.sin(2*np.pi*f*t + k) + .3*np.sin(2*np.pi*2*f*t) for k, f in enumerate(freqs))
    return amp * env * s / len(freqs)

def add(buf, sig, at, pan=0.0):
    i = int(at * SR); j = min(n, i + len(sig))
    if i >= n: return
    L[i:j] += sig[:j-i] * (1 - pan) ; Rr[i:j] += sig[:j-i] * (1 + pan)

# melodía
t = START
for note, d in mel:
    add(None, box(N(note + 12), amp=.55), t, pan=.1)
    add(None, box(N(note), amp=.35), t + .012, pan=-.1)
    t += d * E
# acompañamiento: arpegio de caja musical + colchón
for b, c in enumerate(chords):
    t0 = START + b * 6 * E
    if t0 > DUR: break
    notes = CH[c]
    for k, nn in enumerate([notes[0], notes[2], notes[3], notes[1], notes[2], notes[3]]):
        add(None, box(N(nn), dur=1.8, amp=.16 if k else .26), t0 + k*E, pan=(-.35 if k % 2 else .35))
    add(None, pad([N(x) for x in notes[1:]], 6*E + .6, .06), t0)
# cascabeles suaves en cada pulso
rng = np.random.default_rng(3)
def bell(dur=.25):
    t = np.arange(int(SR*dur))/SR
    noise = rng.standard_normal(len(t))
    hp = np.diff(noise, prepend=0)              # brillo
    return hp * np.exp(-t*22) * .05
tb = START + 3*E*4
while tb < START + 17*6*E:
    add(None, bell(), tb, pan=.5); tb += 3*E
# reverberación (respuesta impulsiva sintética)
ir_t = np.arange(int(SR*2.2))/SR
def rev(x, seed):
    ir = np.random.default_rng(seed).standard_normal(len(ir_t)) * np.exp(-ir_t*2.6); ir[0] = 0
    y = np.fft.irfft(np.fft.rfft(x, 2*len(x)) * np.fft.rfft(ir, 2*len(x)))[:len(x)]
    return y
L2 = L + .045*rev(L, 1); R2 = Rr + .045*rev(Rr, 2)
st = np.stack([L2, R2], 1)
fade = np.ones(n); fo = int(SR*1.8); fade[-fo:] = np.linspace(1, 0, fo)
st *= fade[:, None]
st /= np.abs(st).max() / 0.85
with wave.open(sys.argv[1] if len(sys.argv) > 1 else 'musica.wav', 'w') as w:
    w.setnchannels(2); w.setsampwidth(2); w.setframerate(SR)
    w.writeframes((st * 32767).astype('<i2').tobytes())
