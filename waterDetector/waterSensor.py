# ttyACM0
import serial
import time

ser = serial.Serial('/dev/ttyACM1')  # open serial port
ser.timeout = 5
print(ser.name)         # check which port was really used
while(True):
    n = 0
    for i in range(10):
        ser.write(b"getAdc_A0\r")
        ans = ser.readline()
        if ans == b'':
            continue
        print(ans)
        adcCount = int(ans)
        print(adcCount)
        # print("dummy")
        if adcCount > 500:
            n += 1
    if n >= 10:    
        ser.write(b"setLedOff\r")     # write a string
        time.sleep(0.2)
        ser.write(b"setLedOn\r")     # write a string
        time.sleep(0.2)
    else:
        ser.write(b"setLedOff\r")
        time.sleep(0.4)
ser.close()             # close port