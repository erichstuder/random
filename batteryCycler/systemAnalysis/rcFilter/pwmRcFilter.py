from control.matlab import *
import matplotlib.pyplot as plt

# The PWM frequency is 980Hz (about 6157 rad/s)
# The damping at this frequency shall be at least 30dB (factor 1000)

T1 = 1/800  #1/6

s = tf('s')

g = 1/(1+T1*s)

mag, phase, w = bode(g*g*g, omega_limits=[10, 6157], dB=True, plot=False)
#y, t = step(g)

plt.ion()
plt.style.use('dark_background')
#plt.xlabel('Time [s]')
#plt.ylabel('Amplitude')
#plt.title('Step response for 1. Order Lowpass')
plt.grid(linestyle='--')
plt.loglog(w, mag)
#plt.plot(w, phase)
#plt.plot(t, y)

input("press enter to exit ...")
