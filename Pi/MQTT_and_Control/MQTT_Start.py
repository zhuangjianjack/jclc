import paho.mqtt.client as mqtt
import json_converse
from Serial_Module import read_ser
import get_data_module
import os
import time
import socket_module
import threading

MQTTHOST = "118.24.19.135"
MQTTPORT = 1883
mqttClient = mqtt.Client()


# 连接MQTT服务器
def on_mqtt_connect():
    mqttClient.connect(MQTTHOST, MQTTPORT, 60)
    mqttClient.loop_start()


# publish 消息
def on_publish(topic, payload, qos):
    mqttClient.publish(topic, payload, qos)


# 消息处理函数
def on_message_come(client, userdata, msg):
    msg.payload = str(msg.payload,"utf-8")
    new_messages = json_converse.converse_json_to_data(msg.payload)
    if len(new_messages) == False:
        pass
    else:
        on_publish('jcsf/gh/iotdata', new_messages, 2)



# subscribe 消息
def on_subscribe():
    mqttClient.on_message = on_message_come  # 消息到来处理函数
    mqttClient.subscribe('jcsf/gh/control', 2)
   



def MQTT_Start():
    on_mqtt_connect()
    msg = read_ser()
    sen1,sen2,sen3,sen4,sen5,sen6 = get_data_module.data_trasmit(msg)
    dict_Sens = json_converse.get_json_from_sen(sen1,sen2,sen3,sen4,sen5,sen6)
    #print(dict_Sens)
    on_publish('jcsf/gh/iotdata',str(dict_Sens),0)
    on_subscribe()
    mqttClient.loop_start()
    while True:
        pass

def thread_start(dict_Sens):
    t1 = threading.Thread(target=thread1,args=(dict_Sens,))
    t2 = threading.Thread(target=thread2,args=(dict_Sens,))
    t1.start()
    t2.start()
    t1.join()
    t2.join()
def thread1(dict_Sens):
    try:
        socket_module.sent_msg(dict_Sens)
    except:
        pass
def thread2(dict_Sens):
    try:
        on_publish('jcsf/gh/iotdata',dict_Sens,0)
    except:
        pass

if __name__ == "__main__":
    
    pid = os.fork()
    if pid == 0:
        while True:
            on_mqtt_connect()
            msg = read_ser()
            sen1,sen2,sen3,sen4,sen5,sen6 = get_data_module.data_trasmit(msg)
            dict_Sens = json_converse.get_json_from_sen(sen1,sen2,sen3,sen4,sen5,sen6)
            if dict_Sens == False:
                time.sleep(1)
                continue
            time.sleep(0.5)
            

            t = threading.Thread(target=thread_start,args=(dict_Sens,))
            t.start()
            t.join(1)
            
            #socket_module.sent_msg(dict_Sens)
            #on_publish('jcsf/gh/iotdata',dict_Sens,1)
            #print(dict_Sens)
            mqttClient.loop_start()

    else:
        while True:
            on_mqtt_connect()
            on_subscribe()
            mqttClient.loop_start()           
            while True:
                pass

