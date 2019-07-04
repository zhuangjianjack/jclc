import datetime
import json
import Serial_Module
import socket_module
from collections import OrderedDict

def SenData_to_json(sen1=0,sen2=0,sen3=0,sen4=0,sen5=0,sen6=0):
    get_time = datetime.datetime.now().strftime('%Y,%m,%d,%H,%M,%S')
    v1 = get_time.split(',')
    for i in range(0, len(v1)):
        tmp = v1[i]
        if tmp[0] == "0":
            v1[i] = tmp[1::]

    order_data1 = OrderedDict()
    order_data1['ID'] = 1
    order_data1['Type'] = 1
    order_data1['Data'] = sen1
    
    order_data2 = OrderedDict()
    order_data2['ID'] = 2
    order_data2['Type'] = 2
    order_data2['Data'] = sen2
    
    order_data3 = OrderedDict()
    order_data3['ID'] = 3
    order_data3['Type'] = 3
    order_data3['Data'] = sen3
    
    order_data4 = OrderedDict()
    order_data4['ID'] = 4
    order_data4['Type'] = 3
    order_data4['Data'] = sen4
    
    order_data5 = OrderedDict()
    order_data5['ID'] = 5
    order_data5['Type'] = 3
    order_data5['Data'] = sen5
    
    order_data6 = OrderedDict()
    order_data6['ID'] = 10
    order_data6['Type'] = 4
    order_data6['Data'] = sen6
    
    order_sens = OrderedDict()
    order_sens['Obj'] = 'Sens'
    order_sens['Num'] = 6
    order_sens['Payload'] = [order_data1,order_data2,order_data3,order_data4,order_data5,order_data6]
    order_sens['Time'] = [int(v1[0]), int(v1[1]), int(v1[2]), int(v1[3]), int(v1[4]), int(v1[5])]
    
    '''
    dict_data1 = {
        'ID': 1,
        'Type': 1,
        'Data': sen1
    }
    dict_data2 = {
        'ID': 2,
        'Type': 2,
        'Data': sen2

    }
    dict_data3 = {
        'ID': 3,
        'Type': 3,
        'Data': sen3
    }
    dict_data4 = {
        'ID': 4,
        'Type': 3,
        'Data': sen4

    }
    dict_data5 = {
        'ID': 5,
        'Type': 3,
        'Data': sen5
    }
    dict_data6 = {
        'ID': 10,
        'Type': 4,
        'Data': sen6

    }
    
    dict_Sens = {
        'Obj': 'Sens',
        'Num': 6,
        'Payload': [dict_data1, dict_data2, dict_data3, dict_data4, dict_data5, dict_data6],
        'Time': [int(v1[0]), int(v1[1]), int(v1[2]), int(v1[3]), int(v1[4]), int(v1[5])],

    }
    
    return dict_Sens
    '''
    return order_sens
def get_json_from_sen(sen1,sen2,sen3,sen4,sen5,sen6):
    if sen1[0] == float(0):
        return False
    else:
        dict_Sens = SenData_to_json(sen1,sen2,sen3,sen4,sen5,sen6)
        t1 = json.dumps(dict_Sens,ensure_ascii=False)
        with open('Sen_Data.txt','w+') as f:
            f.write(t1)
            f.close()
        return t1
        #on_publish('jcsf/gh/control',t1,0)
        #return sen1,sen2,sen3,sen4,sen5,sen6

def CTLData_to_json(data1,data2,data3,data4,data5):
    get_time = datetime.datetime.now().strftime('%Y,%m,%d,%H,%M,%S')
    v1 = get_time.split(',')
    for i in range(0, len(v1)):
        tmp = v1[i]
        if tmp[0] == "0":
            v1[i] = tmp[1::]
            
    dict_ctl1 = OrderedDict()
    dict_ctl1['ID'] = 1
    dict_ctl1['Type'] = 1
    dict_ctl1['Data'] = [data1]
    
    dict_ctl2 = OrderedDict()
    dict_ctl2['ID'] = 2
    dict_ctl2['Type'] = 2
    dict_ctl2['Data'] = [data2]
    
    dict_ctl3 = OrderedDict()
    dict_ctl3['ID'] = 3
    dict_ctl3['Type'] = 3
    dict_ctl3['Data'] = [data3]
    
    dict_ctl4 = OrderedDict()
    dict_ctl4['ID'] = 4
    dict_ctl4['Type'] = 4
    dict_ctl4['Data'] = [data4]
    
    dict_ctl5 = OrderedDict()
    dict_ctl5['ID'] = 5
    dict_ctl5['Type'] = 5
    dict_ctl5['Data'] = [data5]

    dict_base_ctl = OrderedDict()
    dict_base_ctl['Obj'] = 'SW'
    dict_base_ctl['Num'] = 5
    dict_base_ctl['Payload'] = [dict_ctl1,dict_ctl2,dict_ctl3,dict_ctl4,dict_ctl5]
    dict_base_ctl['Time'] = [int(v1[0]), int(v1[1]), int(v1[2]), int(v1[3]), int(v1[4]), int(v1[5])]
   
    '''
    dict_data1 = {
        'ID': 1,
        'Type': 1,
        'Data': [data1]
    }
    dict_data2 = {
        'ID': 2,
        'Type': 2,
        'Data': [data2]

    }
    dict_data3 = {
        'ID': 3,
        'Type': 3,
        'Data': [data3]
    }
    dict_data4 = {
        'ID': 4,
        'Type': 3,
        'Data': [data4]

    }
    dict_data5 = {
        'ID': 5,
        'Type': 3,
        'Data': [data5]
    }
    base_data = {
        'Obj': 'SW',
        'Num': 5,
        'Payload': [dict_data1, dict_data2, dict_data3, dict_data4, dict_data5],
        'Time': [int(v1[0]), int(v1[1]), int(v1[2]), int(v1[3]), int(v1[4]), int(v1[5])],

    }

    t1 = json.dumps(base_data, ensure_ascii=False)
    '''
    t1 = json.dumps(dict_base_ctl, ensure_ascii=False)
    with open('CTL_Data.txt', 'w+') as f:
        f.write(t1)
        f.close()


def cmp_LF():
    with open('CTL_Data.txt', 'r') as f:
        x = f.readline()
        f.close()
    dict_r = json.loads(x)
    list_r = dict_r['Payload']
    list1 = list_r[0]
    list2 = list_r[1]
    list3 = list_r[2]
    list4 = list_r[3]
    list5 = list_r[4]

    data1 = list1['Data']
    data2 = list2['Data']
    data3 = list3['Data']
    data4 = list4['Data']
    data5 = list5['Data']

    data1 = data1[0]
    data2 = data2[0]
    data3 = data3[0]
    data4 = data4[0]
    data5 = data5[0]
    return data1, data2, data3, data4, data5

def converse_json_to_data(recv_msg):
    dict_data = json.loads(recv_msg)
    #print(dict_data)
    data1,data2,data3,data4,data5 = cmp_LF()
    if dict_data['Cmd'] == "Action":
        if dict_data['ID'] == 1:
            if data1 != dict_data['Param']:
                data1 = dict_data['Param']
                CTLData_to_json(data1,data2,data3,data4,data5)
                ctl1 = "@c,1,%s#" % data1
                Serial_Module.write_ser(ctl1.encode("utf-8"))

        if dict_data['ID'] == 2:
            if data2 != dict_data['Param']:
                data2 = dict_data['Param']
                CTLData_to_json(data1,data2,data3,data4,data5)
                ctl2 = "@c,2,%s#" % data2
                Serial_Module.write_ser(ctl2)

        if dict_data['ID'] == 3:
            if data3 !=  dict_data['Param']:
                data3 = dict_data['Param']
                CTLData_to_json(data1,data2,data3,data4,data5)
                ctl3 = "@c,3,%s#" % data3
                Serial_Module.write_ser(ctl3)
                

        if dict_data['ID'] == 4:
            if data4 !=  dict_data['Param']:
                data4 = dict_data['Param']
                CTLData_to_json(data1,data2,data3,data4,data5)
                ctl4 = "@c,4,%s#" % data4
                Serial_Module.write_ser(ctl4)
                

        if dict_data['ID'] == 5:
            if data5 !=  dict_data['Param']:
                data5 = dict_data['Param']
                CTLData_to_json(data1,data2,data3,data4,data5)
                ctl5 = "@c,5,%s#" % data5
                Serial_Module.write_ser(ctl5)
                
        with open('CTL_Data.txt','r') as f:
            CTL_msg = f.readline()
            f.close()
        socket_module.sent_msg(CTL_msg)
        
        return False



    if dict_data['Cmd'] == "Query":
        with open("CTL_Data.txt", 'r') as f:
            messages = f.readline()
            f.close()
        #print(messages)
        messages = str(messages)
        new_messages = ""
        for i in range(0, len(messages)):
            #if  i != 208 and i != 209:
            new_messages = new_messages + messages[i]
        #print(new_messages)
        return new_messages
        #on_publish('jcsf/gh/iotdata', new_messages, 2)

    if dict_data['Cmd'] == "PTSet":
        set_time = dict_data['Param']
        msg = "@d,%s#"%set_time
        Serial_Module.write_ser(msg)
        return False