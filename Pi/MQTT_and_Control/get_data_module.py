from json_converse import get_json_from_sen,CTLData_to_json,cmp_LF
from Serial_Module import write_ser
def data_trasmit(str_rec):
    
    if str_rec == None:
        data1 = [0.0,0.0,0]
        data2 = [0.0,0.0,0]
        data3 = [0.0,0.0]
        data4 = [0.0,0.0]
        data5 = [0.0,0.0]
        data6 = [0.0,0.0]
        return data1,data2,data3,data4,data5,data6
    
    data1 = [0.0,0.0,0]
    data2 = [0.0,0.0,0]
    data3 = [0.0,0.0]
    data4 = [0.0,0.0]
    data5 = [0.0,0.0]
    data6 = [0.0,0.0]
    
    #str_rec = "@1,12.95,12,13#@2,21.8,22,23#@3,38.1,32#@4,41,42#@5,51,52#@6,61,62#"
    s1 = str_rec.split('@')
    s1.pop(0)
    for i in range(0, len(s1)):
        s1[i] = s1[i].replace('#', '')
    # print(s1)

    for i in range(0, len(s1)):
        tmp = s1[i].split(',')
        # print(tmp)
        if tmp[0] == "a":
            tmp.pop(0)
            if tmp[0] == "1":
                try:
                    tmp.pop(0)
                    tmp[0] = float(tmp[0])
                    tmp[1] = float(tmp[1])  # ERROR export to could not convert string to float
                    tmp[2] = int(tmp[2])
                    data1 = tmp
                    # print(data1)
                except:
                    print("export to could not convert string to float")
                    import datetime

                    print(datetime.datetime.now().strftime('%Y,%m,%d,%H,%M,%S'))
                    pass
            if tmp[0] == "2":
                try:
                    tmp.pop(0)
                    tmp[0] = float(tmp[0])
                    tmp[1] = float(tmp[1])
                    tmp[2] = int(tmp[2])  # ERROT export to list index out of range
                    data2 = tmp
                    # print(data2)
                except:
                    print("export to list index out of range")
                    import datetime

                    print(datetime.datetime.now().strftime('%Y,%m,%d,%H,%M,%S'))
                    pass
            if tmp[0] == "3":
                try:
                    tmp.pop(0)
                    tmp[0] = float(tmp[0])
                    tmp[1] = float(tmp[1])
                    data3 = tmp
                    # print(data3)
                except:
                    pass
            if tmp[0] == "4":
                try:
                    tmp.pop(0)
                    tmp[0] = float(tmp[0])
                    tmp[1] = float(tmp[1])
                    data4 = tmp
                    # print(data4)
                except:
                    pass
            if tmp[0] == "5":
                try:
                    tmp.pop(0)
                    tmp[0] = float(tmp[0])
                    tmp[1] = float(tmp[1])
                    data5 = tmp
                    # print(data5)
                except:
                    pass
            if tmp[0] == "10":
                try:
                    tmp.pop(0)
                    tmp[0] = float(tmp[0])
                    tmp[1] = float(tmp[1])
                    data6 = tmp
                    # print(data6)
                except:
                    pass

        if tmp[0] == "b":  # control failed return
            tmp.pop(0)
            if tmp[1] == "3":
                print("control failed")
            else:
                pass

        if tmp[0] == "c":  # set interval time error return
            tmp.pop(0)
            if tmp[1] == "0":
                print("set interval time failed")
            if tmp[1] == "1":
                pass

    return data1,data2,data3,data4,data5,data6