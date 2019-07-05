import serial
import time

ser = serial.Serial("/dev/ttyAMA0", 9600)
def read_ser():
    time.sleep(0.1)
    count = ser.inWaiting()
    if count != 0:
        recv_msg = ser.read(count)
        ser.flushInput()
        time.sleep(0.3)
        #print(str(recv_msg,encoding="utf-8"))
        return str(recv_msg,encoding="utf-8")
        
def write_ser(msg):
    #print(msg)
    ser.write(msg)
    #time.sleep(0.1)

